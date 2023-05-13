// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./ZKPVerifier.sol";
import "./Utils.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract ETHGlobalPOAPContract is ERC20, ZKPVerifier {
    enum ETHGlobalAttendeeResponse {
        BAD,
        AVERAGE,
        GOOD,
        GREAT,
        AWESOME
    }

    uint64 public TRANSFER_REQUEST_ID = 1;

    mapping(address => uint256) public addressToId;
    mapping(uint256 => address) public idToAddress;
    mapping(address => ETHGlobalAttendeeResponse)
        public ethGlobalAttendeeSurvey;
    mapping(address => uint16) public voteCounts;

    uint64 public count;
    mapping(uint64 => ETHGlobalAttendeeResponse)
        public ethGlobalAttendeeResponses;

    uint256 public TOKEN_AMOUNT_FOR_AIRDROP_PER_ID = 5 * 10 ** uint(decimals());

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {
        count = 0;
    }

    function _beforeProofSubmit(
        uint64,
        uint256[] memory inputs,
        ICircuitValidator validator
    ) internal view override {
        // check that challenge input of the proof is equal to the msg.sender
        address addr = Utils.int256ToAddress(
            inputs[validator.getChallengeInputIndex()]
        );
        require(
            _msgSender() == addr,
            "address in proof is not a sender address"
        );
    }

    function _afterProofSubmit(
        uint64 requestId,
        uint256[] memory inputs,
        ICircuitValidator validator
    ) internal override {
        require(
            requestId == TRANSFER_REQUEST_ID && addressToId[_msgSender()] == 0,
            "proof can not be submitted more than once"
        );

        uint256 id = inputs[validator.getChallengeInputIndex()];
        // execute the airdrop
        if (idToAddress[id] == address(0)) {
            super._mint(_msgSender(), TOKEN_AMOUNT_FOR_AIRDROP_PER_ID);
            addressToId[_msgSender()] = id;
            idToAddress[id] = _msgSender();
        }
    }

    function _beforeTokenTransfer(
        address,
        address to,
        uint256
    ) internal view override {
        require(
            proofs[to][TRANSFER_REQUEST_ID] == true,
            "only identities who provided proof are allowed to receive tokens"
        );
        require(
            voteCounts[to] > 0,
            "user must have submitted a survey response"
        );
    }

    function submitSurveyAttendee(
        address attendeeAddress,
        ETHGlobalAttendeeResponse response
    ) internal {
        require(
            proofs[attendeeAddress][TRANSFER_REQUEST_ID] == true,
            "only identities who provided proof are allowed to vote"
        );
        require(
            voteCounts[attendeeAddress] == 0,
            "identities cannot double vote"
        );
        ethGlobalAttendeeSurvey[attendeeAddress] = response;
        ethGlobalAttendeeResponses[count] = response;
        voteCounts[attendeeAddress] = 1;
        count += 1;
    }

    function getCount() external view returns (uint64) {
        return count;
    }
}
