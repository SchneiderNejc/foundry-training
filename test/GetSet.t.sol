pragma solidity 0.8.15;

import "forge-std/Test.sol";
import "src/GetSet.sol";

contract GetSetTest is Test {
    // contract instances
    GetSet getSet;

    function setUp() public {
        getSet = new GetSet();
    }
}
