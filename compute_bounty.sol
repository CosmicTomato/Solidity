pragma solidity ^0.5.10;


contract Mortal {
    address payable public owner = msg.sender;
    function die( address payable beneficiary ) public{
        require( (owner == msg.sender), "Only the owner can self destruct the contract" );
        selfdestruct(beneficiary);
    }
}

contract ComputeBounty is Mortal{

    function actualComputation( uint trialSolution ) public pure returns(uint) {
        uint answer = (17**trialSolution)%31;
        //correct answer is 11

        //uint answer = (5196209**trialSolution)%4737301;
        //correct answer is 2416327
        return( answer );
    }

    uint public desiredAnswer = 22;
    //uint public desiredAnswer = 2080750;

    bool public solutionFound = false;
    uint256 public solution = 0;

    function trySolution( uint trialSolution ) public returns(bool) {
        if( checkSolution(trialSolution) ){
            require( (solutionFound == false), "The (a) solution has already been found" );
            solutionFound = true;
            solution = trialSolution;
            owner = msg.sender;
            return true;
        }else{
            return false;
        }
    }

    function checkSolution( uint trialSolution ) internal view returns(bool) {
        if ( actualComputation( trialSolution ) == desiredAnswer ) {
            return true;
        }else{
            return false;
        }
    }

    //fallback. allows contract to receive ether.
    function() external payable {
    }

}
