pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";

contract QuestLootLoom is ERC721Full {
    // Transfer Gateway contract address
    address public gateway;

    address owner;
    address ownerContract;
    uint256 tokenID;
    string name;
    string symbol;
    bool initiated;

    mapping(uint256 => string) private lootModels;

    constructor(address _gateway) public ERC721Full("DelendaLoot", "DELoot") {
        gateway = _gateway;
        // owner = msg.sender;
        initiated = false;
        tokenID = 0;
        name = "DelendaLoot";
        symbol = "DELoot";
        lootModels[1] = "https://gateway.ipfs.io/ipfs/QmSDNJoB9ae8Bas6zzyVjGkVaMJhM1qcStGufhEGJQajdp";
        lootModels[2] = "https://gateway.ipfs.io/ipfs/QmYQnUT44cZECQKjsYsgdYQ6wmSerSYN5stiKvoLCTHL56";
        lootModels[3] = "https://gateway.ipfs.io/ipfs/QmSU1TYpaw8tgGesRdgzDcFjcj62hRbJyfARYrCBraz2KQ";
    }

    modifier onlyOwnerContract {
        require(
            msg.sender == ownerContract,
            "Only the controlling contract can use this function"
        );
        _;
    }

    function initiateOwnerContract(address ownerContractInput)
        public
    /*onlyOwner*/
    {
        require(initiated == false, "The contract has already been initiated");
        ownerContract = ownerContractInput;
        initiated = true;
    }

    function mintAndIncrement(address recipient)
        public
        onlyOwnerContract
        returns (uint256)
    {
        tokenID++;
        _mint(recipient, tokenID);
        return tokenID;
    }

    function getLootModel(uint256 tokenIDInput)
        public
        view
        returns (string memory)
    {
        require(msg.sender == ownerOf(tokenIDInput), "You do not own this NFT");
        return lootModels[tokenIDInput];
    }
    // Used by the DAppChain Gateway to mint tokens that have been deposited to the Ethereum Gateway
    function mintToGateway(uint256 _uid) public {
        require(msg.sender == gateway, "only the gateway is allowed to mint");
        _mint(gateway, _uid);
    }
}
