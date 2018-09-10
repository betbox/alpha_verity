pragma solidity ^0.4.0;

import "./Owned.sol";
import "./OXTokenInterface.sol";

contract Managed is Owned {

    // The minimum anount of Ether that can be
    // betted in a gamble
    uint256 public  minBet;

    // The fee paid to this contract in case a gamble
    // is completed successfully
    uint32 public   fee;

    // The penalty paid to this contract in case a gamble
    // is cancelled, declined or failed to reveal
    uint32 public   penalty;

    // The total commission collected in this contract
    uint256 public  collectedCommission;

    // The address of the token used to reward bet creators
    OXTokenInterface public  OXToken;

    /**
     * Setter function used to set a new value for the minimum bet.
     * This function is invokable only by the contract owner
     *
     * @param value - The new minimum bet value
     */
    function setMinBet(uint256 value) public onlyOwner {

        minBet = value;
    }

    /**
     * Setter function used to set a new value for the fee. The
     * value is given in per-mille (‰). A value of 1‰ equals to
     * 0.1%. Fails if the given value is above 1000. This function 
     * is invokable only by the contract owner
     *
     * @param value - The new fee value in ‰
     */
    function setFee(uint32 value) public onlyOwner {

        require(value <= 1000, "Value must be between 0 and 1000");
        fee = value;
    }

    /**
     * Setter function used to set a new value for the penalty. 
     * The value is given in per-mille (‰). A value of 1‰ equals 
     * to 0.1%. Fails if the given value is above 1000. This 
     * function is invokable only by the contract owner
     *
     * @param value - The new penalty value in ‰
     */
    function setPenalty(uint32 value) public onlyOwner {

        require(value <= 1000, "Value must be between 0 and 1000");
        penalty = value;
    }

    /**
     * Function used to transfer a specific amount of commission
     * collected in this contract. Uppon successful invocation,
     * the requested value is transferred to the owner. The 
     * requested amount must be less than or equal the current
     * amount of collected commission
     *
     * @param amount - The amount of commission to be transferred
     */
    function collectCommission(uint256 amount) public onlyOwner {
        
        // Cant request more than the collected ammount. If
        // this requirement is not checked, ether that belongs
        // to the users may be stolen by the owner
        require(amount <= collectedCommission, "Requested amount exceeds total collected commission");
        
        // Subtract the withdrawn amount
        collectedCommission -= amount;
        owner.transfer(amount);
    }

    /**
     * Setter function used to set a new address for the OX Token
     * contract. From this point on, the rewards are made from 
     * this contract address
     *
     * @param value - The new penalty value in ‰
     */
    function setTokenAddress(address tokenAddress) public onlyOwner {

        OXToken = OXTokenInterface(tokenAddress);
    }

    /**
     * A constant function that returns OX Token balance of the
     * address that invoked it
     *
     * @return uint256 - The amount of OX Tokens the caller owns
     */
    function getTokenBalance() public view returns (uint256) {
        
        return OXToken.balanceOf(msg.sender);
    }
}
