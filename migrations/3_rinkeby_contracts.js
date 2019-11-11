const QuestCoinRinkeby = artifacts.require("./QuestCoinRinkeby.sol");
const QuestLootRinkeby = artifacts.require("./QuestLootRinkeby.sol");

const gatewayAddress = "0x9c67fD4eAF0497f9820A3FBf782f81D6b6dC4Baa";

module.exports = function(deployer, network, accounts) {
  if (network !== "rinkeby") {
    return;
  }

  deployer.then(async () => {
    await deployer.deploy(QuestCoinRinkeby);
    const myQuestCoinRinkebyInstance = await QuestCoinRinkeby.deployed();

    await deployer.deploy(QuestLootRinkeby, gatewayAddress);
    const myQuestLootRinkebyInstance = await QuestLootRinkeby.deployed();

    console.log(
      "\n*************************************************************************\n"
    );
    console.log(
      `QuestCoinRinkeby Contract Address: ${myQuestCoinRinkebyInstance.address}`
    );
    console.log(
      `QuestLootRinkeby Contract Address: ${myQuestLootRinkebyInstance.address}`
    );
    console.log(
      "\n*************************************************************************\n"
    );
  });
};
