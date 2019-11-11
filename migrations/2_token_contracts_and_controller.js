const QuestCoinLoom = artifacts.require("./QuestCoinLoom.sol");
const QuestLootLoom = artifacts.require("./QuestLootLoom.sol");
const QuestController = artifacts.require("./QuestController.sol");

const gatewayAddress = "0xe754d9518bf4a9c63476891ef9AA7d91C8236A5D";

module.exports = function(deployer, network, accounts) {
  if (network === "rinkeby") {
    return;
  }

  deployer.then(async () => {
    await deployer.deploy(QuestCoinLoom, gatewayAddress);
    const myQuestCoinLoomInstance = await QuestCoinLoom.deployed();

    await deployer.deploy(QuestLootLoom, gatewayAddress);
    const myQuestLootLoomInstance = await QuestLootLoom.deployed();

    console.log(
      "\n*************************************************************************\n"
    );
    console.log(
      `QuestCoinLoom Contract Address: ${myQuestCoinLoomInstance.address}`
    );
    console.log(
      `QuestLootLoom Contract Address: ${myQuestLootLoomInstance.address}`
    );
    console.log(
      "\n*************************************************************************\n"
    );
    await deployer.deploy(
      QuestController,
      myQuestCoinLoomInstance.address,
      myQuestLootLoomInstance.address
    );
  });
};
