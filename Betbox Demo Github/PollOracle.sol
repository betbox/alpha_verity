pragma solidity ^0.4.0;

import "./VerityEventInterface.sol";

contract PollOracle {

    /**
     * A function used to check the Verity Oracle contract if 
     * the result of voting is present. The Verity contract will 
     * return a non-empty string once the result is present
     *
     * @param eventContract - The address of the contract
     * @return bool - An indication whether the result is reported
     */
    function isEventReported(address eventContract) public view returns (bool) {

        return bytes(VerityEvent(eventContract).getResult()).length > 0;
    }

    /**
     * A function get the result from the Verity Oracle contract.
     * The result must be already reported, i.e. the returned string
     * must not be empty. If the result is reported, and the returned
     * value is "true", the result is 'true', otherwise, the result
     * is false
     *
     * @param eventContract - The address of the contract
     * @return bool - The result from the oracle
     */
    function getEventResult(address eventContract) public view returns (bool) {

        // The result must be already reported
        require(isEventReported(eventContract), "This event has not been reported yet");

        // Check if the result equals the string value "true"
        return keccak256(abi.encodePacked(VerityEvent(eventContract).getResult())) == keccak256("true");
    }
}