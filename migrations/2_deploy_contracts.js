const Migrations = artifacts.require("TodoList");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
