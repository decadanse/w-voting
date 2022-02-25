// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;


import "../seed/Seed.sol"; //need this
// import "../utils/interface/Safe.sol"; // import "../test/Imports.sol";
// import "../utils/SignerV2.sol";

import "../gnosis/GnosisSafe.sol";

// import "./SampleModule.sol";
import "hardhat/console.sol";

// interface GnosisSafeVV2 is Safe{
//     /// @dev Allows a Module to execute a Safe transaction without any further confirmations.
//     /// @param to Destination address of module transaction.
//     /// @param value Ether value of module transaction.
//     /// @param data Data payload of module transaction.
//     /// @param operation Operation type of module transaction.
//     function execTransactionFromModule(address to, uint256 value, bytes calldata data, Enum.Operation operation)
//         external
//         returns (bool success);

//     function execTransaction(
//         address to,
//         uint256 value,
//         bytes calldata data,
//         Enum.Operation operation,
//         uint256 safeTxGas
//     ) external returns (bool success);
// }

/// @title Voting with delegation.
contract Ballot {
    Seed public seed;
    // Safe public gnosis;
    GnosisSafe public safe;

    // RecoveryKeyModule rkmc;
    // ILBP public lbp; // Address of LBP that is managed by this contract.
    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Voter {
        uint256 weight; // = balanceOf(address(this)); // weight is accumulated by stacking balance
        bool voted; // if true, that person already voted
        address delegate; // person delegated to
        uint256 vote; // index of the voted proposal
    }

    // This is a type for a single proposal.
    struct Proposal {
        bytes32 name; // short name (up to 32 bytes)
        uint256 voteCount; // number of accumulated votes
    }

    address public chairperson;

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // A dynamically-sized array of `Proposal` structs.
    Proposal[] public proposals;

    /// Create a new ballot to choose one of `proposalNames`.
    constructor(bytes32[] memory proposalNames, Seed _seed, GnosisSafe _safe) {
        require(proposalNames.length != 0, "Proposals can not be empty");

        seed = _seed;
        safe = _safe;
        // console.log(" safe  is %s", address(safe));
        // console.log(" seed  is %s", address(seed));
        // console.log(" seed admin is %s", seed.admin.address);

        chairperson = msg.sender;

        uint256 basic_weight = 1;        
        if (seed.fundingCollected() != 0){
            basic_weight = seed.fundingCollected();
        }

        voters[chairperson].weight = basic_weight; 

        // For each of the provided proposal names,
        // create a new proposal object and add it
        // to the end of the array.
        for (uint256 i = 0; i < proposalNames.length; i++) {
            // `Proposal({...})` creates a temporary
            // Proposal object and `proposals.push(...)`
            // appends it to the end of `proposals`.
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    //test func
    function checkVoterBalance(address voter) public view returns (uint256 balance) {
        balance = voters[voter].weight;
    }

    function addOwnerToGnosis(address owner) public {
        // Owner address cannot be null, the sentinel or the Safe itself.
        require(owner != address(0));
        // console.log("msg.sender  is %s", msg.sender);
        // console.log("executer  is %s", executer);
        // require(msg.sender == executer);

        //Only allow if caller has enough weight (51% and more)
        // require(seed.seedAmountForFunder(owner)/100 >= seed.fundingCollected()/100*51, "not enough funds in pool"); 
        require(seed.calculateClaim(msg.sender)*100 >= seed.fundingCollected()/100*51, "not enough funds in pool"); 
        // console.log("seed.seedAmountForFunder(owner)  is %s", seed.seedAmountForFunder(msg.sender));
        console.log("seed.calculateClaim(owner)  is %s", seed.calculateClaim(msg.sender));
        console.log("seed.fundingCollected() is %s", seed.fundingCollected());
        // console.log("seed.feeForFunder(owner)  is %s", seed.feeForFunder(msg.sender));        
        // console.log("addOwnerToGnosis owner is %s", owner);
        // console.log("addOwnerToGnosis chairperson is %s", chairperson);
        // console.log("addOwnerToGnosis seed is %s", address(seed));
        // console.log("addOwnerToGnosis safe is %s", address(safe));        
        // console.log("addOwnerToGnosis admin is %s", admin); //admin.address = chairperson.address
        // console.log("chairperson is %s", chairperson);

        address[] memory array = safe.getOwners();
        console.log("getOwners is %s : %s \n", address(array[0]), address(array[1]));
     
        safe.addOwnerWithThreshold(owner, 1);

        array = safe.getOwners();
        console.log("getOwners is %s : %s :%s \n", address(array[0]), address(array[1]), address(array[2]));  
    }

//https://github.com/gnosis/safe-core-sdk/blob/main/packages/safe-core-sdk/src/managers/ownerManager.ts
    function removeOwnerFromGnosis(address forRemOwner, address owner) public {
        // Owner address cannot be null, the sentinel or the Safe itself.
        require(owner != address(0));
        //Only allow if caller has enough weight (51% and more)
        require(seed.calculateClaim(msg.sender)*100 >= seed.fundingCollected()/100*51, "not enough funds in pool");

        address[] memory array = safe.getOwners(); //part if later edit for to pass only 1 arg to removeOwnerFromGnosis
        console.log("getOwners is %s : %s :%s \n", address(array[0]), address(array[1]), address(array[2])); 

        // uint256 previous = 0;     
        // uint256 len = array.length;
        // for (uint256 i = 1; i < len; i++) {
        //     if (array[i] == forRemOwner){
        //         previous = i - 1;
        //     }     
        //         console.log(array[i]);       
        // }
        // address beforeForRemOwner = array[previous];
        // console.log(previous);


        // require(len > safe.getThreshold(), "ownerCount must be >= threshold");
        // require(beforeForRemOwner != forRemOwner);

        // console.log("safe.getThreshold() is %s \n", safe.getThreshold());        
        console.log("owner is %s \n", owner);
        // console.log("beforeForRemOwner is %s \n", beforeForRemOwner);
        console.log("forRemOwner is %s \n", forRemOwner);
        // safe.removeOwner(beforeForRemOwner, forRemOwner, 1);
        safe.removeOwner(owner, forRemOwner, 1);  

        array = safe.getOwners();
        console.log("getOwners is %s : %s \n", address(array[0]), address(array[1]));
    }

    // Give `voter` the right to vote on this ballot.
    // May only be called by `chairperson`.
    function giveRightToVote(address voter) public {
        // If the first argument of `require` evaluates
        // to `false`, execution terminates and all
        // changes to the state and to Ether balances
        // are reverted.
        // This used to consume all gas in old EVM versions, but
        // not anymore.
        // It is often a good idea to use `require` to check if
        // functions are called correctly.
        // As a second argument, you can also provide an
        // explanation about what went wrong.
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(!voters[voter].voted, "The voter already voted.");
        require(voters[voter].weight == 0);
        voters[voter].weight = seed.calculateClaim(voter); //uncomment 
    }

    /// Delegate your vote to the voter `to`.
    function delegate(address to) public {
        // assigns reference
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");

        require(to != msg.sender, "Self-delegation is disallowed.");

        // Forward the delegation as long as
        // `to` also delegated.
        // In general, such loops are very dangerous,
        // because if they run too long, they might
        // need more gas than is available in a block.
        // In this case, the delegation will not be executed,
        // but in other situations, such loops might
        // cause a contract to get "stuck" completely.
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // We found a loop in the delegation, not allowed.
            require(to != msg.sender, "Found loop in delegation.");
        }

        // Since `sender` is a reference, this
        // modifies `voters[msg.sender].voted`
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate_.weight += sender.weight;
        }
    }

    /// Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`.
    function vote(uint256 proposal) public {
        Voter storage sender = voters[msg.sender];

        //sender.weight = seed.calculateClaim(msg.sender); //upd balance info

        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        // If `proposal` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Computes the winning proposal taking all
    /// previous votes into account.
    function winningProposal() public view returns (uint256 winningProposal_) {
        uint256 winningVoteCount = 0;
        for (uint256 p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function getAllProposals() external view returns (Proposal[] memory) {
        Proposal[] memory items = new Proposal[](proposals.length);
        for (uint256 i = 0; i < proposals.length; i++) {
            items[i] = proposals[i];
        }
        return items;
    }

    // Calls winningProposal() function to get the index
    // of the winner contained in the proposals array and then
    // returns the name of the winner
    function winnerName() public view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}
