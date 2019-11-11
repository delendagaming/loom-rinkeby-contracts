pragma solidity ^0.5.6;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract QuestCoinRinkeby is ERC20 {

    string public name = "DelendaToken";
    string public symbol = "DEL";
    uint8 public decimals = 18;

    // one billion in initial supply
    uint256 public constant INITIAL_SUPPLY = 1000000000;

    constructor() public {
        uint256 totalSupply = INITIAL_SUPPLY * (10 ** uint256(decimals));
        _mint(msg.sender, totalSupply);
    }
}

