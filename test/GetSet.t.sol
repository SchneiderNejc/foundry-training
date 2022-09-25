pragma solidity 0.8.15;

import "forge-std/Test.sol";
import "src/GetSet.sol";

contract GetSetTest is Test {
    // contract instances
    GetSet getSet;

    event LogValues(bool value, uint identifier);
    event ValuesArray(uint[] values);

    //--------------------------------------------------------------------------
    // setUp, test and testCannot

    function setUp() public {
        getSet = new GetSet();
    }

    function testValueIsFalse() public {
        assertFalse(getSet.getValue());
    }

    function testCannotSetSameValue() public {
        vm.expectRevert(bytes("cant set same value"));
        getSet.setValue(false);
    }

    //--------------------------------------------------------------------------
    // console.log

    function testConsoleLogValues() public view {
        bool value = getSet.getValue();
        console.log("value: %s identifier: %s", value, getSet.identifier());
    }

    //--------------------------------------------------------------------------
    // std logs
    function testEmitValues() public {
        emit LogValues(getSet.getValue(), getSet.identifier());
    }

    function testEmitArray() public {
        uint[] memory data = getSet.getValues();
        emit ValuesArray(data);
    }

    //--------------------------------------------------------------------------
    // std assertions

    // TODO

    //--------------------------------------------------------------------------
    // std cheats

    // skip rewind
    function testOnlyInFuture() public {
        assertFalse(getSet.onlyInFuture());

        skip(60);
        assertTrue(getSet.onlyInFuture());

        rewind(45);
        assertFalse(getSet.onlyInFuture());
    }

    // prank, hoax
    function testOnlyOwner() public {
        assertFalse(getSet.onlyOwner());

        //vm.prank only works for the next call
        vm.prank(0xE71d14a3fA97292BDE885C1D134bE4698e09b3B7);
        assertTrue(getSet.onlyOwner());
        assertFalse(getSet.onlyOwner());

        // multiple return value
        address sender;
        address owner;
        (sender, owner) = getSet.getSenderOwner();
        console.log("sender: %s :: owner: $s", sender, owner);
    }





}
