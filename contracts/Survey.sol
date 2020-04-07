pragma solidity ^0.6.1;

/// @title Marketplace for survey creators - A survey instant created by SurveyFactory to randomize the process of fees
/// @author dhruvin.parikh@georgebrown.ca

contract Survey {
    /* Events */
    event SurveyInitialized(address indexed owner,uint indexed surveyReward);

    /* Contract State */
    address public owner;
    address private factory;

    constructor(address _owner) payable public {
        require(_owner != address(0),"onwer's address should not be zero");
        require(msg.value > 0, "value of ether should be non-zero");

        owner = _owner;
        factory = msg.sender;
        emit SurveyInitialized(owner, msg.value);
    }
}