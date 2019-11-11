pragma solidity ^0.5.0;

import  "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";

contract QuestLootLoom is ERC721Full {
    // Transfer Gateway contract address
    address public gateway;

     address owner;
     address ownerContract;
     uint tokenID;
     string name;
     string symbol;
     bool initiated;
    
    mapping(uint => string) private lootModels;
    
    constructor (address _gateway) ERC721Full("DelendaLoot", "DELoot") public {
        gateway = _gateway;
       // owner = msg.sender;
       initiated = false;
        tokenID = 0;
        name = "DelendaLoot";
        symbol = "DELoot";
        lootModels[1] = 'https://firebasestorage.googleapis.com/v0/b/delendaproto.appspot.com/o/Loot%20pictures%2FTrophy-cup-monochrome-icon-Vector-on-white-background-by-Hoeda80-1-580x386.jpg?alt=media&token=319bcc48-8046-4e6e-970e-87ff8e2fd385';
        lootModels[2] = 'https://firebasestorage.googleapis.com/v0/b/delendaproto.appspot.com/o/Loot%20pictures%2Ftrophy-cup.png?alt=media&token=10ff53b3-05cc-47ce-8479-9c776fc13394';
        lootModels[3] = 'https://firebasestorage.googleapis.com/v0/b/delendaproto.appspot.com/o/Loot%20pictures%2Ftrophy.png?alt=media&token=7ec45b0d-c42c-4447-8a9b-59ac90354dbc';
    }
    
    modifier onlyOwnerContract {
        require(
            msg.sender == ownerContract, "Only the controlling contract can use this function"        );
        _;
    } 
    
    function initiateOwnerContract (address ownerContractInput) public /*onlyOwner*/ {
        require(initiated == false, "The contract has already been initiated");
        ownerContract = ownerContractInput;
        initiated = true;
    }

    function mintAndIncrement (address recipient) public onlyOwnerContract returns (uint) {
       tokenID++;
        _mint(recipient, tokenID);
        return tokenID;
    }

    function getLootModel (uint tokenIDInput) public view returns (string memory) {
        require(msg.sender == ownerOf(tokenIDInput), "You do not own this NFT");
        return lootModels[tokenIDInput];
    }
    // Used by the DAppChain Gateway to mint tokens that have been deposited to the Ethereum Gateway
    function mintToGateway (uint256 _uid) public
    {
        require(msg.sender == gateway, "only the gateway is allowed to mint");
        _mint(gateway, _uid);
    }
}