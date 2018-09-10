pragma solidity ^0.4.0;

contract VerityEvent {

    /** 
     * A function on the Verity Oracle contract used to for
     * reading the voting outcome. The string returned from
     * this function can be empty, indicating that the result
     * is not present yet
     *
     * @return string - The result stored in the contract
     *
     */
    function getResult() public view returns (string);
}