pragma solidity ^0.6.1;

import "./Survey.sol";
import "./Ownable.sol";
import "./SafeMath.sol";

/// @title SurveyFactory - Create surveys and charge users
/// @author dhruvin.parikh@georgebrown.ca

contract SurveyFactory is Ownable {

    /* Declare safemath for uint */
    using SafeMath for uint;

    /* Events */
    event SurveyFactoryInitialized(uint indexed surveyCreationFees);
    event SurveyCreated(uint indexed surveyId, address indexed surveyAddress);

    /* Contract State */
    uint public surveyCreationFees;
    address[] public surveys;
    mapping(uint => address) public surveyToOwner;
    uint public counter = 0;

    /* Modifiers */
    modifier notTheOwner() {
        require(msg.sender != owner(), "Sender should not be the owner");
        _;
    }

    /// @notice Contructor of the Survey Factory Contract
    /// @param _surveyCreationFees - The fees to charge the survey creator when their survey is created
    /// @dev Intiliase the survey factory with the survey creation fees.
    constructor(uint _surveyCreationFees) public {
        surveyCreationFees = _surveyCreationFees;
        emit SurveyFactoryInitialized(surveyCreationFees);
    }

    function createSurvey() external payable notTheOwner returns(uint surveyId, address newSurveyAddress){
        require(msg.value > surveyCreationFees, "Value must be greater than survey creation fees");
        
        /* Calculate Reward */
        uint surveyReward = msg.value.sub(surveyCreationFees);

        /* Create new instance of the survey */
        address _newSurveyAddress = address((new Survey).value(surveyReward)(msg.sender));

        /* Calculate surveyId */
        surveys.push(_newSurveyAddress);
        counter++;
        // uint _surveyId = i.sub(1);

        surveyToOwner[counter] = msg.sender;

        emit SurveyCreated(counter, _newSurveyAddress);
        return (counter, _newSurveyAddress);
    }
}