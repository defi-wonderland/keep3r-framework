// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.19;

import {EnumerableSet} from 'openzeppelin/utils/structs/EnumerableSet.sol';

import {IKeep3rSponsor, IKeep3rV2, IKeep3rHelper} from '../../interfaces/periphery/IKeep3rSponsor.sol';
import {IAutomationVault, IOpenRelay} from '../../interfaces/relays/IOpenRelay.sol';

/**
 * @title  Keep3rSponsor
 * @notice This contract managed by Keep3r Network will sponsor some execution in determined jobs
 */

contract Keep3rSponsor is IKeep3rSponsor {
  using EnumerableSet for EnumerableSet.AddressSet;

  /// @inheritdoc IKeep3rSponsor
  IKeep3rV2 public immutable KEEP3R_V2;

  /// @inheritdoc IKeep3rSponsor
  IKeep3rHelper public immutable KEEP3R_HELPER;

  /// @inheritdoc IKeep3rSponsor
  uint32 public immutable BASE = 10_000;

  /// @inheritdoc IKeep3rSponsor
  uint256 public bonus = 15_000;

  /// @inheritdoc IKeep3rSponsor
  IOpenRelay public openRelay;

  /// @inheritdoc IKeep3rSponsor
  address public owner;

  /// @inheritdoc IKeep3rSponsor
  address public pendingOwner;

  /// @inheritdoc IKeep3rSponsor
  address public feeRecipient;

  /**
   * @notice List of sponsored jobs
   */
  EnumerableSet.AddressSet internal _sponsoredJobs;

  /**
   * @param _owner The address of the owner
   * @param _feeRecipient The address of the fee recipient
   * @param _openRelay The address of the open relay
   * @param _keep3rV2 The address of the keep3rV2
   * @param _keep3rHelper The address of the keep3rHelper
   */
  constructor(
    address _owner,
    address _feeRecipient,
    IOpenRelay _openRelay,
    IKeep3rV2 _keep3rV2,
    IKeep3rHelper _keep3rHelper
  ) {
    owner = _owner;
    feeRecipient = _feeRecipient;
    openRelay = _openRelay;
    KEEP3R_V2 = _keep3rV2;
    KEEP3R_HELPER = _keep3rHelper;
  }

  /// @inheritdoc IKeep3rSponsor
  function getSponsoredJobs() external view returns (address[] memory _sponsoredJobsList) {
    _sponsoredJobsList = _sponsoredJobs.values();
  }

  /// @inheritdoc IKeep3rSponsor
  function changeOwner(address _pendingOwner) external onlyOwner {
    pendingOwner = _pendingOwner;
    emit ChangeOwner(_pendingOwner);
  }

  /// @inheritdoc IKeep3rSponsor
  function acceptOwner() external onlyPendingOwner {
    pendingOwner = address(0);
    owner = msg.sender;
    emit AcceptOwner(msg.sender);
  }

  /// @inheritdoc IKeep3rSponsor
  function setFeeRecipient(address _feeRecipient) external onlyOwner {
    feeRecipient = _feeRecipient;
    emit FeeRecipientSetted(_feeRecipient);
  }

  /// @inheritdoc IKeep3rSponsor
  function setOpenRelay(IOpenRelay _openRelay) external onlyOwner {
    openRelay = _openRelay;
    emit OpenRelaySetted(_openRelay);
  }

  /// @inheritdoc IKeep3rSponsor
  function setBonus(uint256 _bonus) external onlyOwner {
    if (_bonus < BASE) revert Keep3rSponsor_LowBonus();
    bonus = _bonus;
    emit BonusSetted(_bonus);
  }

  /// @inheritdoc IKeep3rSponsor
  function addSponsoredJobs(address[] calldata _jobs) public onlyOwner {
    for (uint256 _i; _i < _jobs.length;) {
      _sponsoredJobs.add(_jobs[_i]);
      emit ApproveSponsoredJob(_jobs[_i]);

      unchecked {
        ++_i;
      }
    }
  }

  /// @inheritdoc IKeep3rSponsor
  function deleteSponsoredJobs(address[] calldata _jobs) public onlyOwner {
    for (uint256 _i; _i < _jobs.length;) {
      _sponsoredJobs.remove(_jobs[_i]);

      emit DeleteSponsoredJob(_jobs[_i]);
      unchecked {
        ++_i;
      }
    }
  }

  function exec(IAutomationVault _automationVault, IAutomationVault.ExecData[] calldata _execData) external {
    if (_execData.length == 0) revert Keep3rSponsor_NoJobs();

    // The first call to `isKeeper` ensures the caller is a valid keeper
    bool _isKeeper = KEEP3R_V2.isKeeper(msg.sender);
    if (!_isKeeper) revert Keep3rSponsor_NotKeeper();

    for (uint256 _i; _i < _execData.length;) {
      if (!_sponsoredJobs.contains(_execData[_i].job)) revert Keep3rSponsor_JobNotSponsored();

      unchecked {
        ++_i;
      }
    }

    uint256 _initialGas = gasleft();
    openRelay.exec(_automationVault, _execData, feeRecipient);
    uint256 _gasAfterWork = gasleft();

    uint256 _reward = IKeep3rHelper(KEEP3R_HELPER).getRewardAmountFor(msg.sender, _initialGas - _gasAfterWork);
    _reward = (_reward * bonus) / BASE;
    KEEP3R_V2.bondedPayment(msg.sender, _reward);
  }

  /**
   * @notice Checks that the caller is the owner
   */
  modifier onlyOwner() {
    address _owner = owner;
    if (msg.sender != _owner) revert Keep3rSponsor_OnlyOwner();
    _;
  }

  /**
   * @notice Checks that the caller is the pending owner
   */
  modifier onlyPendingOwner() {
    address _pendingOwner = pendingOwner;
    if (msg.sender != _pendingOwner) revert Keep3rSponsor_OnlyPendingOwner();
    _;
  }
}
