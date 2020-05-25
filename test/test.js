const {
  expectRevert,
} = require('@openzeppelin/test-helpers');

const AutoDeployer = artifacts.require('AutoDeployerMock');

contract('AutoDeployer', function () {
  describe('#_autoDeploy', function () {
    describe('()', function () {
      it('deploys functional clone contract', async function () {
        let instance = await AutoDeployer.new();

        for (let i = 0; i < 10; i++) {
          let address = await instance.autoDeploy.call();
          await instance.autoDeploy();
          instance = await AutoDeployer.at(address);
        }
      });
    });

    describe('(uint)', function () {
      it('deploys functional clone contract', async function () {
        let instance = await AutoDeployer.new();

        for (let i = 0; i < 10; i++) {
          let address = await instance.autoDeploy.call(1);
          await instance.autoDeploy(1);
          instance = await AutoDeployer.at(address);
        }
      });

      describe('reverts if', function () {
        it('salt has already been used', async function () {
          let instance = await AutoDeployer.new();
          await instance.autoDeploy(1);

          await expectRevert(
            instance.autoDeploy(1),
            'AutoDeployer: failed deployment'
          );
        });
      });
    });
  });

  describe('#_calculateDeploymentAddress', function () {
    it('returns deployment address for a given salt', async function () {
      let instance = await AutoDeployer.new();
      let predicted = await instance.calculateDeploymentAddress.call(1);
      let deployed = await instance.autoDeploy.call(1);

      assert.equal(predicted, deployed);
    });
  });
});
