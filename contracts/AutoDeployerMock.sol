// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import './AutoDeployer.sol';

contract AutoDeployerMock is AutoDeployer {
  function autoDeploy () external returns (address) {
    return _autoDeploy();
  }

  function autoDeploy (uint salt) external returns (address) {
    return _autoDeploy(salt);
  }

  function calculateDeploymentAddress (uint salt) external view returns (address) {
    return _calculateDeploymentAddress(salt);
  }
}
