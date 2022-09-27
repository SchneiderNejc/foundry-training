pragma solidity 0.8.15;

import "forge-std/Test.sol";
import "src/GetSet.sol";
import "src/AdditionalDeployment.sol";


contract GetSetTest is Test {
    // for accessing/modify contract storage
    using stdStorage for StdStorage;
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
    function testOnlyUser() public {
        assertFalse(getSet.onlyUser());

        //vm.prank only works for the next call
        vm.prank(0xE71d14a3fA97292BDE885C1D134bE4698e09b3B7);
        assertTrue(getSet.onlyUser());
        assertFalse(getSet.onlyUser());

        // multiple return value
        (address sender, address owner) = getSet.getSenderUser();
        console.log("sender: %s :: owner: $s", sender, owner);
    }

    // ERC20 methods
    // hoax -> prank from funded address,
    // startHoax ->  perpetual prank from funded address,
    // deal -> mint erc20

    // changePrank -> stopPrank + startPrank
    // useful when startPrank is setUp, to deactivate it in certain tests

    // deployCode
    function testCannotDeployCodeWithInvalidParams() public {
        vm.expectRevert(bytes("number cant be 0"));
        deployCode("AdditionalDeployment.sol",
            abi.encode(0, 0xE71d14a3fA97292BDE885C1D134bE4698e09b3B7));


        vm.expectRevert(bytes("invalid address"));
        deployCode("AdditionalDeployment.sol",
            abi.encode(5, address(0)));
    }

    // makeAddr
    // does not require import contract
    function testDeployCode() public {

        // hash string input to generate address
        address nejc = makeAddr("nejc");
        console.log(nejc);

        // deploy additional contract and save its address
        address additionalDeployment = deployCode("AdditionalDeployment.sol",
            abi.encode(5, nejc));
        console.log("additionalDeployment: %s", additionalDeployment);

        // retrieve stored address from newly deployed contract
        (bool success, bytes memory data) = additionalDeployment.call(
            abi.encodeWithSignature("getOwner()"));
        assertTrue(success);

        // extract return value from .call
        address owner = abi.decode(data, (address));
        console.log("newly deployed contract owner: $s", owner);
        assertEq(owner, nejc);
    }

    // bound
    function testSetIdentifier(uint number) public {
        number = bound(number, 5, 20);
        // assume
        vm.assume(number != 10);
        bool success = getSet.setIdentifier(number);
        assertTrue(success);
    }

    // makeAddrAndKey
    // (address alice, uint256 key) = makeAddrAndKey("alice");

    // std store (write)
    function testUpdateStorageWithForge() public {
        // read/write public variable
        stdstore
            .target(address(getSet))
            .sig("identifier()")
            .checked_write(100);

        uint identifier = stdstore
            .target(address(getSet))
            .sig("identifier()")
            .read_uint();
        console.log("identifier: ", identifier);

        // write to struct inside public mapping
        stdstore
            .target(address(getSet))
            .sig("people(address)")
            .with_key(address(this))
            .depth(0)
            .checked_write(120);
        stdstore
            .target(address(getSet))
            .sig("people(address)")
            .with_key(address(this))
            .depth(1)
            .checked_write("Chief");

        // read from struct inside public mapping
        uint rank = stdstore
            .target(address(getSet))
            .sig("people(address)")
            .with_key(address(this))
            .depth(0)
            .read_uint();

        bytes32 position = stdstore
            .target(address(getSet))
            .sig("people(address)")
            .with_key(address(this))
            .depth(1)
            .read_bytes32();

        console.log("rank %s has position %s", rank, string(abi.encodePacked(position)));
    }

    // std math
    function testMathWithForge() public {
        // abs - absolute value
        console.log("absolute no. of -5 is: ", stdMath.abs(-5));

        // delta - difference between two no. in absolute value
        console.log("distance between -4 and 3 is: ", stdMath.delta(-4, 3));

        // percentDelta - difference between two numbers in percentage
        // 125 = 50 * 150% :: 50 = 125 *60%
        console.log("First was 50 employees. Now are 125. Its %s% compared to begining.",
            stdMath.percentDelta(uint(125), 50)/10e15);
        console.log("First was 125 employees. Now are 50. Its %s% compared to begining.",
            stdMath.percentDelta(uint(50), 125)/10e15);
    }

    // computeCreateAddress - NOT WORKING
    function testPredeterminedDeployment() public {
        // input: deployer, nonce
        address calculatedAddress = computeCreateAddress(address(this), 1);

        GetSet getSet = new GetSet();

        address owner = getSet.owner();
        assertEq(address(this), owner);   //returns true

        // assertEq(calculatedAddress, address(getSet));  // returns false
    }


}
