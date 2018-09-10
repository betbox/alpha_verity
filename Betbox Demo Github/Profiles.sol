pragma solidity ^0.4.0;

contract Profiles {

    // Events that get emitted when their respective
    // events occur. The 'to' parameter should be
    // filtered by the recipient with their own address
    event Participated(bytes32 betHash, address player, uint256 amount, bool answer, uint256 timestamp);
    event Cancelled(bytes32 betHash);
    event Won(address to, bytes32 betHash);
    event Lost(address to, bytes32 betHash);


    // A data structure describing each member profile.
    // Each bet is stored in an list for ease of 
    // listing, but also stored in a map in order to 
    // consume a constant amount of gas when searching
    struct Profile {
        
        // List and map for the active bets
        bytes32[]                   activeBets;
        mapping (bytes32=>uint256)  activeBetsIndices;

        // List and map for the completed bets
        bytes32[]                   completedBets;
        mapping (bytes32=>uint256)  completedBetsIndices;
    }


    // A map containing all the user profiles in the contract
    mapping (address=>Profile)      internal profiles;


    /**
     * A constant function that returns an array containing the 
     * hashes of each active bet
     *
     * @returns bytes32[] - The array of active bets
     */
    function getActiveBets() public view returns (bytes32[]) {
        
        return profiles[msg.sender].activeBets;
    }

    /**
     * A constant function that returns an array containing the 
     * hashes of each completed bet
     *
     * @returns bytes32[] - The array of completed bets
     */
    function getCompletedBets() public view returns (bytes32[]) {
        
        return profiles[msg.sender].completedBets;
    }


    /**
     * An internal function that adds a bet hash to the list of
     * active bets of a specified member. The hash is pushed to the
     * end of the list, and its index is added to the map. Fails if
     * the bet hash already exists in the map
     *
     * @param profile - The address of the target member
     * @param betHash - The hash of the bet to add
     */
    function addToActiveBets(address profile, bytes32 betHash) internal {

        // The list index for the bet hash must not exist in the map
        require(profiles[profile].activeBetsIndices[betHash] == 0, "This bet already exists");

        // The push operation adds the item to the front of the list
        // and returns the new length of the list, which is stored in the map
        uint256 betIndex = profiles[profile].activeBets.push(betHash);
        profiles[profile].activeBetsIndices[betHash] = betIndex;
    }

    /**
     * An internal function that removes a bet hash from the list of
     * active bets of a specified member. The hash is removed by replacing
     * the value at its index with the value of the last index. The list is
     * then narrowed by 1, and the index for the bet hash in the map set
     * to 0, indicating that the bet does not exist in the list
     *
     * @param profile - The address of the target member
     * @param betHash - The hash of the bet to remove
     */
    function deleteFromActiveBets(address profile, bytes32 betHash) internal {

        // The list index for the bet hash must exist in the map
        require(profiles[profile].activeBetsIndices[betHash] != 0, "This bet does not exist");

        // The bet index is retrieved from the map.
        uint256 betIndex = profiles[profile].activeBetsIndices[betHash] - 1;

        // The value at the index position is replaced by the last value in the list
        profiles[profile].activeBets[betIndex] = profiles[profile].activeBets[profiles[profile].activeBets.length - 1];
        
        // The list is narrowed by 1
        profiles[profile].activeBets.length--;

        // The bet index is removed from the map
        profiles[profile].activeBetsIndices[betHash] = 0;
    }

    /**
     * An internal function that adds a bet hash to the list of
     * completed bets of a specified member. The hash is pushed to the
     * end of the list, and its index is added to the map. Fails if
     * the bet hash already exists in the map
     *
     * @param profile - The address of the target member
     * @param betHash - The hash of the bet to add
     */
    function addToCompletedBets(address profile, bytes32 betHash) internal {

        // The list index for the bet hash must not exist in the map
        require(profiles[profile].completedBetsIndices[betHash] == 0, "This bet already exists");

        // The push operation adds the item to the front of the list
        // and returns the new length of the list, which is stored in the map
        uint256 betIndex = profiles[profile].completedBets.push(betHash);
        profiles[profile].completedBetsIndices[betHash] = betIndex;
    }

    /**
     * An internal function that removes a bet hash from the list of
     * completed bets of a specified member. The hash is removed by replacing
     * the value at its index with the value of the last index. The list is
     * then narrowed by 1, and the index for the bet hash in the map set
     * to 0, indicating that the bet does not exist in the list
     *
     * @param profile - The address of the target member
     * @param betHash - The hash of the bet to remove
     */
    function deleteFromCompletedBets(address profile, bytes32 betHash) internal {

        // The list index for the bet hash must exist in the map
        require(profiles[profile].completedBetsIndices[betHash] != 0, "This bet does not exist");

        // The bet index is retrieved from the map.
        uint256 betIndex = profiles[profile].completedBetsIndices[betHash] - 1;

        // The value at the index position is replaced by the last value in the list
        profiles[profile].completedBets[betIndex] = profiles[profile].completedBets[profiles[profile].completedBets.length - 1];
        
        // The list is narrowed by 1
        profiles[profile].completedBets.length--;

        // The bet index is removed from the map
        profiles[profile].completedBetsIndices[betHash] = 0;
    }
}
