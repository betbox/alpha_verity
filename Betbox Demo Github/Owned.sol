pragma solidity ^0.4.0;

contract Owned {

    // Holds the address of the owner of the contract
    // who is able to perform contract management operations
    address public owner;

    // Holds the address of the invited party to become
    // the new contract owner. This is switched back to
    // address(0) once the new owner accepts.
    address public newOwner;
    

    // An event emitted when the ownership is successfully
    // transferred to the new owner
    event OwnershipTransferred(address indexed _from, address indexed _to);

    // Function modifier for functions accessable
    // only by the owner of the contract
    modifier onlyOwner {

        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }


    /**
     * Constructor of the contract. Initializes the owner
     * address as the address of the contract creator
     */
    constructor() public {

        owner = msg.sender;
        newOwner = address(0);
    }

    /**
     * Invites another party to become the new owner of
     * the contract. Current owner is still in charge until
     * the new owner accepts the incitation. Current owner 
     * can revoke the invitation by calling this function
     * again with address(0), assuming it has not been accepted
     *
     * @param _newOwner The address of the new owner
     */
    function transferOwnership(address _newOwner) public onlyOwner {

        newOwner = _newOwner;
    }

    /**
     * Invoked by the invited party to accept the ownership
     * invitation. Must be called from the address stored
     * in newOwner. Once this call succeeds, the owner is changed
     * and an OwnershipTransferred event is emitted
     */
    function acceptOwnership() public {

        require(msg.sender == newOwner, "This function can be called only by the new owner address");
        
        owner = newOwner;
        newOwner = address(0);

        emit OwnershipTransferred(owner, newOwner);
    }
}
