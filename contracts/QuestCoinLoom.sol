pragma solidity ^0.5.6;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract QuestCoinLoom is ERC20 {
    // Transfer Gateway contract address
    address public gateway;
    
    string public name = "DelendaToken";
    string public symbol = "DEL";
    uint8 public decimals = 18;

    
    constructor(address _gateway) public {
        gateway = _gateway;
    }

    // Used by the DAppChain Gateway to mint tokens that have been deposited to the Ethereum Gateway
    function mintToGateway(uint256 _amount) public {
        require(msg.sender == gateway, "only the gateway is allowed to mint");
       _mint(gateway, _amount);
    }
}
