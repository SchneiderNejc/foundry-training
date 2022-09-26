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

    // prank
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

    // ERC20 methods
    // hoax -> prank from funded address,
    // startHoax ->  perpetual prank from funded address,
    // deal -> mint erc20

    // deployCode
    function testCannotDeployCodeWithInvalidParams() public {
        vm.expectRevert(bytes("number cant be 0"));
        deployCode("AdditionalDeployment.sol",
            abi.encode(0, 0xE71d14a3fA97292BDE885C1D134bE4698e09b3B7));


        vm.expectRevert(bytes("invalid address"));
        deployCode("AdditionalDeployment.sol",
            abi.encode(5, address(0)));
    }

    function testDeployCode() public {
        // deploy additional contract and save its address
        address additionalDeployment = deployCode("AdditionalDeployment.sol",
            abi.encode(5, 0xE71d14a3fA97292BDE885C1D134bE4698e09b3B7));
        console.log("additionalDeployment: %s", additionalDeployment);

        // retrieve stored address from newly deployed contract
        (bool success, bytes memory data) = additionalDeployment.call(
            abi.encodeWithSignature("getOwner()"));
        assertTrue(success);

        // extract return value from .call
        address owner = abi.decode(data, (address));
        console.log("newly deployed contract owner: $s", owner);
    }







}
