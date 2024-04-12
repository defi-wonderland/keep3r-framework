// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {CommonIntegrationTest} from '../integration/Common.t.sol';

import {IAutomationVault} from '../../interfaces/core/IAutomationVault.sol';
import {IKeep3rV2} from '../../interfaces/external/IKeep3rV2.sol';
import {IKeep3rHelper} from '../../interfaces/external/IKeep3rHelper.sol';
import {IKeep3rV1} from '../../interfaces/external/IKeep3rV1.sol';
import {IKeep3rBondedRelay} from '../../interfaces/relays/IKeep3rBondedRelay.sol';
import {_KEEP3R_V2, _KEEP3R_HELPER, _KEEP3R_V1, _KEEP3R_GOVERNOR, _KP3R_WHALE} from './Constants.sol';

contract IntegrationKeep3rSponsor is CommonIntegrationTest {
  // Events
  event KeeperValidation(uint256 _gasLeft);
  event KeeperWork(
    address indexed _credit, address indexed _job, address indexed _keeper, uint256 _amount, uint256 _gasLeft
  );

  // Keep3r contracts
  IKeep3rV2 public keep3r;
  IKeep3rHelper public keep3rHelper;
  IKeep3rV1 public kp3r;

  // EOAs
  address public keep3rGovernor;

  function setUp() public override {
    // AutomationVault setup
    CommonIntegrationTest.setUp();

    // Keep3r setup
    keep3rGovernor = _KEEP3R_GOVERNOR;
    keep3r = _KEEP3R_V2;
    keep3rHelper = _KEEP3R_HELPER;
    kp3r = _KEEP3R_V1;

    _addJobAndLiquidity(address(keep3rSponsor), 1000 ether);

    // Keep3rSponsor array
    address[] memory _keep3rSponsor = new address[](1);
    _keep3rSponsor[0] = address(keep3rSponsor);

    // Job selectors array
    bytes4[] memory _jobSelectors = new bytes4[](2);
    _jobSelectors[0] = basicJob.work.selector;
    _jobSelectors[1] = basicJob.workHard.selector;

    // Job data array
    IAutomationVault.JobData[] memory _jobsData = new IAutomationVault.JobData[](1);
    _jobsData[0] = IAutomationVault.JobData(address(basicJob), _jobSelectors);

    startHoax(owner);

    // AutomationVault approve relay data
    automationVault.addRelay(address(openRelay), _keep3rSponsor, _jobsData);

    // Keep3rSponsor job
    address[] memory _jobs = new address[](1);
    _jobs[0] = address(basicJob);
    keep3rSponsor.addSponsoredJobs(_jobs);

    // Add funds to the automationVault
    address(automationVault).call{value: 100 ether}('');
  }

  function _addJobAndLiquidity(address _job, uint256 _amount) internal {
    keep3r.addJob(_job);

    vm.prank(keep3rGovernor);
    keep3r.forceLiquidityCreditsToJob(_job, _amount);
  }

  function _bondAndActivateKeeper(address _keeper, uint256 _bondAmount) internal {
    changePrank(_KP3R_WHALE);
    kp3r.transfer(_keeper, _bondAmount);

    vm.startPrank(_keeper);
    kp3r.approve(address(keep3r), _bondAmount);
    keep3r.bond(address(kp3r), _bondAmount);

    skip(keep3r.bondTime() + 1);

    keep3r.activate(address(kp3r));
    changePrank(bot);
  }

  function test_executeJobFromKeep3rSponsor() public {
    // Bond and activate keep3r
    _bondAndActivateKeeper(bot, 0);

    IAutomationVault.ExecData[] memory _execData = new IAutomationVault.ExecData[](1);
    _execData[0] = IAutomationVault.ExecData(address(basicJob), abi.encodeWithSelector(basicJob.work.selector));

    vm.expectEmit(true, true, true, false, address(keep3r));
    emit KeeperValidation(0);
    vm.expectEmit(true, true, true, false, address(keep3r));
    emit KeeperWork(address(kp3r), address(keep3rSponsor), bot, 0, 0);

    keep3rSponsor.exec(automationVault, _execData);
  }

  function test_executeAndGetPaymentFromKeep3r(uint64 _fee, uint8 _howHard) public {
    vm.assume(_howHard > 20);
    vm.assume(_fee > 30 gwei && _fee < 200 gwei);
    vm.fee(_fee);

    // Bond and activate keep3r
    _bondAndActivateKeeper(bot, 0);

    // Check that the keeper has no bonded KP3R
    uint256 _payment = keep3r.bonds(bot, address(kp3r));
    assertEq(_payment, 0);

    IAutomationVault.ExecData[] memory _execData = new IAutomationVault.ExecData[](1);
    _execData[0] =
      IAutomationVault.ExecData(address(basicJob), abi.encodeWithSelector(basicJob.workHard.selector, _howHard));

    // Initializes storage variables
    keep3rSponsor.exec(automationVault, _execData);
    _payment = keep3r.bonds(bot, address(kp3r));

    // Execure the job
    uint256 _gasBeforeExec = gasleft();
    keep3rSponsor.exec(automationVault, _execData);
    uint256 _gasAfterExec = gasleft();

    // Calculate the payment in KP3R and after that quote to ETH
    uint256 _paymentInKP3R = keep3r.bonds(bot, address(kp3r)) - _payment;
    uint256 _reward = IKeep3rHelper(_KEEP3R_HELPER).getRewardAmountFor(msg.sender, _gasBeforeExec - _gasAfterExec);

    // Calculate the profit percentage, should be around 150%
    uint256 _profitWithBonus = _reward * keep3rSponsor.bonus() / keep3rSponsor.BASE();

    // Calculate the relation between the payment in KP3R and the profit
    uint256 _relation = _profitWithBonus * 100 / _paymentInKP3R;

    // As we are couting more gas than the actual work, we need to add a margin of error
    assertApproxEqAbs(_relation, 100, 5, 'the keeper should earn around 150% of the ETH cost in bonded KP3R');
  }

  function test_executeAndGetPaymentFromOpenRelayToGovernance(uint64 _fee, uint8 _howHard) public {
    vm.assume(_howHard > 20);
    vm.assume(_fee > 30 gwei && _fee < 200 gwei);
    vm.fee(_fee);

    // Bond and activate keep3r
    _bondAndActivateKeeper(bot, 0);

    // Check that the keeper has no bonded KP3R
    uint256 _payment = keep3r.bonds(bot, address(kp3r));
    assertEq(_payment, 0);

    IAutomationVault.ExecData[] memory _execData = new IAutomationVault.ExecData[](1);
    _execData[0] =
      IAutomationVault.ExecData(address(basicJob), abi.encodeWithSelector(basicJob.workHard.selector, _howHard));

    // Initializes storage variables
    keep3rSponsor.exec(automationVault, _execData);
    uint256 _balanceBefore = address(keep3rGovernor).balance;

    // Execure the job
    uint256 _gasBeforeExec = gasleft();
    keep3rSponsor.exec(automationVault, _execData);
    uint256 _gasAfterExec = gasleft();

    // Calculate the payment in ETH
    uint256 _paymentInEth = address(keep3rGovernor).balance - _balanceBefore;

    // Calculate the profit percentage, should be around 120%
    uint256 _profitInEth = (_gasBeforeExec - _gasAfterExec + openRelay.GAS_BONUS()) * block.basefee
      * openRelay.GAS_MULTIPLIER() / openRelay.BASE();

    // Calculate the relation between the payment in ETH and the profit
    uint256 _relation = _profitInEth * 100 / _paymentInEth;

    // As we are couting more gas than the actual work, we need to add a margin of error
    assertApproxEqAbs(_relation, 100, 10, 'the keep3r sponsor governor should earn around 120% of the ETH');
  }
}
