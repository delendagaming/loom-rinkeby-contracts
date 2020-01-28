pragma solidity ^0.5.6;

import "./QuestCoinLoom.sol";
import "./QuestLootLoom.sol";
import "./Verifier.sol";

contract QuestController {
    // Quest Register section
    address owner;
    address ERC20contract;
    address ERC721contract;

    QuestCoinLoom qt;
    QuestLootLoom ql;

    constructor(address ERC20input, address ERC721input) public {
        owner = msg.sender;
        ERC20contract = ERC20input;
        ERC721contract = ERC721input;

        // instantiate ERC20 & ERC721 contracts
        qt = QuestCoinLoom(ERC20contract);
        ql = QuestLootLoom(ERC721contract);
    }

    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only the contract owner can use this function"
        );
        _;
    }

    struct QuestEntry {
        address creator;
        string identifier;
        address verifierAddress;
        uint256 questPrice;
        string questObjectURLonIPFS;
        string cirDefURLonIPFS;
        string provingKeyURLonIPFS;
    }

    mapping(bytes32 => QuestEntry) public questRegister;
    mapping(address => string) private _playerQuestInProgress;

    event paymentForQuest(
        address payer,
        address recipient,
        string identifierForQuest
    );
    event victory(address player, string questName, uint256 tokenID);
    event incorrectPath(address player, string questName);

    function getHash(string memory questName) public pure returns (bytes32) {
        bytes32 questNameHash;
        questNameHash = sha256(abi.encodePacked(questName));
        return questNameHash;
    }

    function addEntry(
        string memory questName,
        address creatorInput,
        string memory identifierInput,
        address verifierInput,
        uint256 priceInput,
        string memory questObjectURLinput,
        string memory cirDefURLinput,
        string memory provingKeyURLinput
    ) public {
        bytes32 questNameHash;
        questNameHash = sha256(abi.encodePacked(questName));

        //require(questRegister[questNameHash].creator == address(0), "This quest name already exists");

        questRegister[questNameHash].creator = creatorInput;
        questRegister[questNameHash].identifier = identifierInput;
        questRegister[questNameHash].verifierAddress = verifierInput;
        questRegister[questNameHash].questPrice = priceInput;
        questRegister[questNameHash].questObjectURLonIPFS = questObjectURLinput;
        questRegister[questNameHash].cirDefURLonIPFS = cirDefURLinput;
        questRegister[questNameHash].provingKeyURLonIPFS = provingKeyURLinput;
    }

    // Game logic section

    function playerPayment(string memory questName) public {
        // get quest parameters and check that quest exists
        address creator;
        uint256 price;
        string memory identifier;

        bytes32 questNameHash;
        questNameHash = sha256(abi.encodePacked(questName));
        // check that quest exists
        require(
            questRegister[questNameHash].creator != address(0),
            "This quest doesn't exist"
        );
        creator = questRegister[questNameHash].creator;
        price = questRegister[questNameHash].questPrice;
        identifier = questRegister[questNameHash].identifier;

        // check that player isn't on another quest currently
        require(
            bytes(_playerQuestInProgress[msg.sender]).length == 0,
            "You are already playing another quest"
        );

        // check that player has sufficient token balance
        require(qt.balanceOf(msg.sender) > price, "Insufficient token balance");

        // realize payment and emit event

        qt.transferFrom(msg.sender, creator, price);
        _playerQuestInProgress[msg.sender] = questName;
        emit paymentForQuest(msg.sender, creator, identifier);
    }

    function checkAndMint(
        string memory questName,
        uint256[2] memory a,
        uint256[2] memory a_p,
        uint256[2][2] memory b,
        uint256[2] memory b_p,
        uint256[2] memory c,
        uint256[2] memory c_p,
        uint256[2] memory h,
        uint256[2] memory k,
        uint256[1] memory input
    ) public {
        bytes32 questNameHash;
        questNameHash = sha256(abi.encodePacked(questName));

        // checking that player has made payment for this quest and hasn't won or abandoned yet
        require(
            sha256(abi.encodePacked(_playerQuestInProgress[msg.sender])) ==
                sha256(abi.encodePacked(questName)),
            "You are not currently playing this quest."
        );

        bool confirmation;
        confirmation = _checkSolution(
            questName,
            a,
            a_p,
            b,
            b_p,
            c,
            c_p,
            h,
            k,
            input
        );

        if (confirmation == true) {
            uint256 tokenID;
            tokenID = ql.mintAndIncrement(msg.sender);
            _playerQuestInProgress[msg.sender] = "";
            emit victory(msg.sender, questName, tokenID);
        } else {
            emit incorrectPath(msg.sender, questName);
        }

    }

    function _checkSolution(
        string memory questName,
        uint256[2] memory a,
        uint256[2] memory a_p,
        uint256[2][2] memory b,
        uint256[2] memory b_p,
        uint256[2] memory c,
        uint256[2] memory c_p,
        uint256[2] memory h,
        uint256[2] memory k,
        uint256[1] memory input
    ) private view returns (bool) {
        // get quest parameters
        bytes32 questNameHash;
        questNameHash = sha256(abi.encodePacked(questName));

        address verifierAddress;

        verifierAddress = questRegister[questNameHash].verifierAddress;

        // check that verifier contract exists
        require(verifierAddress != address(0));

        Verifier v = Verifier(verifierAddress);
        bool confirmation;
        confirmation = v.verifyProof(a, a_p, b, b_p, c, c_p, h, k, input);
        if (confirmation == true) {
            return true;
        } else {
            return false;
        }
    }

    function abandonCurrentQuest() public {
        require(
            bytes(_playerQuestInProgress[msg.sender]).length > 0,
            "You are not playing any quest currently"
        );
        _playerQuestInProgress[msg.sender] = "";
    }

}
