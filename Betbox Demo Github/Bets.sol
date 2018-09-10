pragma solidity ^0.4.0;

contract Bets {

    // A data structure containing the state of
    // a single participant in a bet. Each bet 
    // has at least one instance of this structure
    struct Participant {

        // Indicates whether the participant
        // has participated in this bet
        bool    active;

        // The amount of Ether betted by the participant
        uint256 betAmount;

        // The answer chosen by the participant
        bool    answer;
    }

    // The data structure that represents a bet.
    // An instance of this struct is created uppon 
    // creation of a new bet, and lives forever.
    struct Bet {

        // Indicates whether this bet exists or not. If this
        // value is false, this bet hash must be invalid
        bool    active;

        // Indicates whether this bet is completed. May
        // be true if cancelled, denied, succeeded or failed
        bool    complete;

        // The time after which the bet is locked and can
        // no longer be accepted
        uint256 lockTime;

        // Timestamp for historical purposes
        uint256 createdOn;

        // The address of the founder of this bet
        address founder;

        // The amount of Ether betted by the founder
        uint256 founderBet;

        // The address of Oracle's contract
        address eventContract;

        // A string containing the prediction for the bet.
        // The prediction could be "Arsenal will lose to Liverpool on Monday"
        string  prediction;


        // Maps participant addresses to their bet contribution and answer
        mapping (address=>Participant) participantData;

        // Holds the list of all the participants that have betted
        // in this bet. This is done for ease of listing
        address[] participantList;


        // Keeps track of the total number of answers
        uint32 totalAnswers;

        // Keeps track of the answers for 'true'
        uint32 answersForTrue;

        // The total amount of Ether betted in this bet
        uint256 totalAmountBetted;
    }


    // Holds a value used as a seed for the next bet ID,
    // also known as the bet hash. This value is accessible
    // only internally
    uint256 internal betNounce;

    // A map of all the bets in existance. Bets are never
    // removed from this list. This value is accessible only internally
    mapping (bytes32=>Bet)   internal bets;

    // A list of all public bets. Bets are never removed from this list
    bytes32[] public betList;


    /**
     * A constant function that returns an array containing the 
     * hashes of each public bet
     *
     * @returns bytes32[] - The array of public bets
     */
    function getPublicBets() public view returns (bytes32[]) {
        
        return betList;
    }

    /**
     * A constant function that returns the number of public 
     * bets created since the creation of this contract
     *
     * @returns uint256 - The number of active bets
     */
    function getPublicBetCount() public view returns (uint256) {
        
        return betList.length;
    }

    /**
     * A constant function that returns the bet details given a
     * bet hash. This function may be used only externally for
     * getting all the details for a specific bet. The function
     * is only accessible by the participants of the bet
     *
     * @param betHash - The hash of the bet to return
     * @returns object - An object containing the hash details
     */
    function getBet(bytes32 betHash) public view 
    returns (
        uint8 state, 
        uint256 createdOn, 
        uint256 lockTime, 
        string prediction, 
        address founder,
        uint256 founderBet,
        uint256 totalAmountBetted) {
        
        // Pack the 'active' field as a flag 
        // into a single byte state register
        if (bets[betHash].active)
            state |= 0x01;

        // Do the same as above for the 'complete' 
        // field, but in flag position 2
        if (bets[betHash].complete)
            state |= 0x02;
        
        createdOn = bets[betHash].createdOn;

        lockTime = bets[betHash].lockTime;

        prediction = bets[betHash].prediction;
        founder = bets[betHash].founder;
        founderBet = bets[betHash].founderBet;
        totalAmountBetted = bets[betHash].totalAmountBetted;
    }

    /**
     * A constant function that returns an array containing the 
     * addresses of each bet participant
     *
     * @returns address[] - The array of bet participants
     */
    function getParticipantList(bytes32 betHash) public view returns (address[]) {
        
        // Return participant list
        return bets[betHash].participantList;
    }

    /* *
     * A constant function that returns the details of a bet 
     * participant given a bet hash and the address of the participant
     *
     * @param betHash - The hash of the bet
     * @param participant - The address of the participant
     * @returns object - An object containing the hash details
     */
    function getParticipant(bytes32 betHash, address participant) public view 
    returns (
        uint256 betAmount, 
        bool answer) {

        // Return participant data
        betAmount = bets[betHash].participantData[participant].betAmount;
        answer = bets[betHash].participantData[participant].answer;
    }

    /* *
     * A constant function that indicates whether a given bet
     * is locked or not. If the bet is locked, it can no longer
     * be participated on by any party. This is done to prevent
     * the participants from accepting the bet after the result
     * is known
     *
     * @param betHash - The hash of the bet to check
     * @returns bool - The lock status of the bet
     */
    function isBetLocked(bytes32 betHash) public view returns (bool) {
        
        return bets[betHash].lockTime < block.timestamp;
    }
}
