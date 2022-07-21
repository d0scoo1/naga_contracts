// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

import './../interfaces/IJBControllerUtility.sol';

//*********************************************************************//
// --------------------------- custom errors -------------------------- //
//*********************************************************************//
error CONTROLLER_UNAUTHORIZED();

/** 
  @notice
  Provides tools for contracts with functionality that can only be accessed by a project's controller.
*/
abstract contract JBControllerUtility is IJBControllerUtility {
  //*********************************************************************//
  // ---------------------------- modifiers ---------------------------- //
  //*********************************************************************//

  modifier onlyController(uint256 _projectId) {
    if (address(directory.controllerOf(_projectId)) != msg.sender) revert CONTROLLER_UNAUTHORIZED();
    _;
  }

  //*********************************************************************//
  // ---------------- public immutable stored properties --------------- //
  //*********************************************************************//

  /** 
    @notice 
    The directory of terminals and controllers for projects.
  */
  IJBDirectory public immutable override directory;

  //*********************************************************************//
  // -------------------------- constructor ---------------------------- //
  //*********************************************************************//

  /** 
    @param _directory A contract storing directories of terminals and controllers for each project.
  */
  constructor(IJBDirectory _directory) {
    directory = _directory;
  }
}
