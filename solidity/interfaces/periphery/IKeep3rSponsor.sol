// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.19;

import {IAutomationVault, IOpenRelay} from '../../interfaces/relays/IOpenRelay.sol';
import {IKeep3rV2} from '../../interfaces/external/IKeep3rV2.sol';
import {IKeep3rHelper} from '../../interfaces/external/IKeep3rHelper.sol';

interface IKeep3rSponsor {
  /*///////////////////////////////////////////////////////////////
                              EVENTS
  //////////////////////////////////////////////////////////////*/

  /**
   * @notice Emitted when a job is executed
   * @param  _job The address of the job
   */
  event JobExecuted(address _job);

  /**
   * @notice Emitted when the owner is proposed to change
   * @param  _pendingOwner The address that is being proposed
   */
  event ChangeOwner(address indexed _pendingOwner);

  /**
   * @notice Emitted when the owner is accepted
   * @param  _owner The address of the new owner
   */
  event AcceptOwner(address indexed _owner);

  /**
   * @notice Emitted when the fee recipient is setted
   * @param  _feeRecipient The address of the new fee recipient
   */
  event FeeRecipientSetted(address indexed _feeRecipient);

  /**
   * @notice Emitted when the open relay is setted
   * @param  _openRelay The address of the new open relay
   */
  event OpenRelaySetted(IOpenRelay indexed _openRelay);

  /**
   * @notice Emitted when the bonus is setted
   * @param _bonus The sponsored bonus
   */
  event BonusSetted(uint256 indexed _bonus);

  /**
   * @notice Emitted when a sponsored job is approved
   * @param  _job The address of the sponsored job
   */
  event ApproveSponsoredJob(address indexed _job);

  /**
   * @notice Emitted when a sponsored job is deleted
   * @param  _job job The address of the sponsored job
   */
  event DeleteSponsoredJob(address indexed _job);

  /*///////////////////////////////////////////////////////////////
                              ERRORS
  //////////////////////////////////////////////////////////////*/

  /**
   * @notice Thrown when the job executed is not in the list of sponsored jobs
   */
  error Keep3rSponsor_JobNotSponsored();

  /**
   * @notice Thrown when the caller is not the owner
   */
  error Keep3rSponsor_OnlyOwner();

  /**
   * @notice Thrown when the caller is not the pending owner
   */
  error Keep3rSponsor_OnlyPendingOwner();

  /**
   * @notice Thrown when the caller is not a keeper
   */
  error Keep3rSponsor_NotKeeper();

  /**
   * @notice Thrown when the exec data is empty
   */
  error Keep3rSponsor_NoJobs();

  /**
   * @notice Thrown when the bonus is lower than the base
   */
  error Keep3rSponsor_LowBonus();

  /*///////////////////////////////////////////////////////////////
                        VIEW FUNCTIONS
  //////////////////////////////////////////////////////////////*/

  /**
   * @notice Returns the keep3rV2 contract
   * @return _keep3rV2 The address of the keep3rV2 contract
   */
  function KEEP3R_V2() external view returns (IKeep3rV2 _keep3rV2);

  /**
   * @notice Returns the keep3r helper contract
   * @return _keep3rHelper The address of the keep3r helper contract
   */
  function KEEP3R_HELPER() external view returns (IKeep3rHelper _keep3rHelper);

  /**
   * @notice Returns the base
   * @return _base The base
   */
  function BASE() external view returns (uint32 _base);

  /**
   * @notice Returns the bonus
   * @dev  The bonus is in base 10_000
   * @return _bonus The bonus
   */
  function bonus() external view returns (uint256 _bonus);

  /**
   * @notice Returns the open relay
   * @return _openRelay The address of the open relay
   */
  function openRelay() external view returns (IOpenRelay _openRelay);

  /**
   * @notice Returns the owner address
   * @return _owner The address of the owner
   */
  function owner() external view returns (address _owner);

  /**
   * @notice Returns the pending owner address
   * @return _pendingOwner The address of the pending owner
   */
  function pendingOwner() external view returns (address _pendingOwner);

  /**
   * @notice Returns the fee recipient address
   * @return _feeRecipient The address of the fee recipient
   */
  function feeRecipient() external view returns (address _feeRecipient);

  /**
   * @notice Returns the list of the sponsored jobs
   * @return _sponsoredJobsList The list of the sponsored jobs
   */
  function getSponsoredJobs() external returns (address[] memory _sponsoredJobsList);

  /*///////////////////////////////////////////////////////////////
                          EXTERNAL FUNCTIONS
  //////////////////////////////////////////////////////////////*/

  /**
   * @notice Propose a new owner for the contract
   * @dev    The new owner will need to accept the ownership before it is transferred
   * @param  _pendingOwner The address of the new owner
   */
  function changeOwner(address _pendingOwner) external;

  /**
   * @notice Accepts the ownership of the contract
   */
  function acceptOwner() external;

  /**
   * @notice Sets the fee recipient who will receive the payment of the open relay
   * @param _feeRecipient The address of the fee recipient
   */
  function setFeeRecipient(address _feeRecipient) external;

  /**
   * @notice Sets the open relay
   * @param _openRelay The address of the open relay
   */
  function setOpenRelay(IOpenRelay _openRelay) external;

  /**
   * @notice Sets the bonus
   * @param _bonus The bonus
   */
  function setBonus(uint256 _bonus) external;

  /**
   * @notice Adds a job to the sponsored list
   * @param  _jobs List of jobs to add
   */
  function addSponsoredJobs(address[] calldata _jobs) external;

  /**
   * @notice Removes a job from the sponsored list
   * @param  _jobs List of jobs to remove
   */
  function deleteSponsoredJobs(address[] calldata _jobs) external;

  /**
   * @notice Execute an open relay which will execute the jobs and will manage the payment to the fee data receivers
   * @param  _automationVault The automation vault that will be executed
   * @param  _execData The array of exec data
   */
  function exec(IAutomationVault _automationVault, IAutomationVault.ExecData[] calldata _execData) external;
}
