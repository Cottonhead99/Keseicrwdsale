pragma solidity ^0.5.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";


// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale  { // UPDATE THE CONTRACT SIGNATURE TO ADD INHERITANCE
    
    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint initialSupply,
        uint rate,
        address payable wallet
    ) public Crowdsale(rate, wallet, token) {
        // constructor can stay empty
    }
}


contract KaseiCoinCrowdsaleDeployer {
    // Create an `address public` variable called `kasei_token_address`.
    address public kasei_token_address;
    // Create an `address public` variable called `kasei_crowdsale_address`.
    address public kasei_crowdsale_address;

    // Add the constructor.
    constructor(string memory tokenName, string memory tokenSymbol, uint initialSupply, uint256 rate, address payable wallet) public {
       
        // Create a new instance of the KaseiCoin contract.
        KaseiCoin kaseiToken = new KaseiCoin(tokenName, tokenSymbol, initialSupply);
         address kasei_token_address = address(kaseiToken);
        
        // Assign the token contract’s address to the `kasei_token_address` variable.
        KaseiCoinCrowdsale kaseiCrowdsale = new KaseiCoinCrowdsale(rate, wallet, IERC20(kasei_token_address));
        address kasei_crowdsale_address = address(kaseiCrowdsale);

        // Create a new instance of the `KaseiCoinCrowdsale` contract
        KaseiCoinCrowdsale kaseiCrowdsale = new KaseiCoinCrowdsale(rate, wallet, kasei_token_address);
        kasei_crowdsale_address = address(kaseiCrowdsale);
            
        // Aassign the `KaseiCoinCrowdsale` contract’s address to the `kasei_crowdsale_address` variable.
        kasei_crowdsale_address = address(kaseiCrowdsale);

        // Set the `KaseiCoinCrowdsale` contract as a minter
        kaseiToken.addMinter(kasei_crowdsale_address);
        kaseiToken.renounceRole(kaseiToken.MINTER_ROLE(), address(this));
        
        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        kaseiToken.renounceRole(kaseiToken.MINTER_ROLE(), address(this));
    }
    
}