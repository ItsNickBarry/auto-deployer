# Solidity AutoDeployer

Solidity utility functions which allow a contract to deploy a copy of itself.

Using the `new` keyword for this purpose will result in a compilation error:

> Circular reference for contract creation (cannot create instance of derived or same contract).

This repository was generated from a template or is the template itself.  For more information, see [docs/TEMPLATE.md](./docs/TEMPLATE.md).

## Usage

Install the package:

```bash
yarn add --dev solidity-auto-deployer
# or
npm install --save-dev solidity-auto-deployer
```

Import and inherit from the contract:

```solidity
import 'solidity-auto-deployer/contracts/AutoDeployer.sol';

contract Factory is AutoDeployer {}
```

Call the `_autoDeploy` function to deploy a copy of the calling contract to a new address.  If a `salt` is provided, the clone will be deployed via the `CREATE2` opcode, allowing for counterfactual deployment:

```solidity
event Deployment(address clone);

function autoDeploy () external {
  address clone = _autoDeploy();
  emit Deployment(clone);
}

function autoDeploy (uint salt) external {
  address clone = _autoDeploy(salt);
  emit Deployment(clone);
}
```

Predict an address for counterfactual deployment:

```solidity
function calculateDeploymentAddress (uint salt) external view returns (address) {
  _calculateDeploymentAddress(salt);
}
```

Note that, due to the deployment mechanism, a clone contract's constructor is not called and variable assignments outside of functions have no effect.

### Warning

If a contract deployed by `AutoDeployer` is able to call the `selfdestruct` function and the `salt` used in its deployment is able to be reused, it will have some properties of metamorphic contracts.  See [0age/metamorphic](https://github.com/0age/metamorphic) for information about the implications.

## Development

Install dependencies via Yarn:

```bash
yarn install
```

Compile contracts via Buidler:

```bash
yarn run buidler compile
```

### Networks

By default, Buidler uses the BuidlerEVM.

To use Ganache, append commands with `--network localhost`, after having started `ganache-cli` in a separate process:

```bash
yarn run ganache-cli
```

To use an external network via URL, set the `URL` environment variable and append commands with `--network generic`:

```bash
URL="https://mainnet.infura.io/v3/[INFURA_KEY]" yarn run buidler test --network generic
```

### Testing

Test contracts via Buidler:

```bash
yarn run buidler test
```

If using a supported network (such as Ganache), activate gas usage reporting by setting the `REPORT_GAS` environment variable to `true`:

```bash
REPORT_GAS=true yarn run buidler test --network localhost
```

Generate a code coverage report for Solidity contracts:

```bash
yarn run buidler coverage
```
