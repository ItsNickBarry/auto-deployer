// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract AutoDeployer {
  bytes private constant _initCode = hex'58333b90818180333cf3';
  bytes32 private constant _initCodeHash = keccak256(abi.encodePacked(_initCode));

  /**
   * @notice deploy a copy of the calling contract
   * @return copy address of deployed contract
   */
  function _autoDeploy () internal returns (address copy) {
    bytes memory initCode = _initCode;

    assembly {
      let encoded_data := add(0x20, initCode)
      let encoded_size := mload(initCode)
      copy := create(0, encoded_data, encoded_size)
    }
  }

  /**
   * @notice deploy a copy of the calling contract
   * @param salt salt passed to create2 for counterfactual deployment
   * @return copy address of deployed contract
   * @dev reverts if deployment is not successful (likely because salt has already been used)
   */
  function _autoDeploy (uint salt) internal returns (address copy) {
    bytes memory initCode = _initCode;

    assembly {
      let encoded_data := add(0x20, initCode)
      let encoded_size := mload(initCode)
      copy := create2(0, encoded_data, encoded_size, salt)
    }

    require(copy != address(0), 'AutoDeployer: failed deployment');
  }

  /**
   * @notice calculate the deployment address for a given salt
   * @dev derived from https://github.com/0age/metamorphic (MIT license)
   * @param salt value to influence deterministic address calculation
   * @return deployment address
   */
  function _calculateDeploymentAddress (uint salt) internal view returns (address) {
    return address(uint160(uint256(keccak256(abi.encodePacked(
      hex'ff',
      address(this),
      salt,
      _initCodeHash
    )))));
  }
}
