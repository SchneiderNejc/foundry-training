pragma solidity 0.8.15;

contract GetSet {

    bool value;
    uint public identifier = 10;
    uint[] public values = [identifier, 4, 3, 2, 1];
    uint timeCreated = block.timestamp;
    address owner = 0xE71d14a3fA97292BDE885C1D134bE4698e09b3B7;

    function getValue() external view returns(bool) {
        return value;
    }

    function setValue(bool _value) external {
        require(value != _value, "cant set same value");
        value = _value;
    }

    function getValues() external view returns(uint[] memory) {
        return values;
    }

    // returns true if 30 seconds after contract created
    function onlyInFuture() external view returns(bool) {
        return block.timestamp > timeCreated + 30;
    }

    function onlyOwner() external view returns(bool) {
        return msg.sender == owner;
    }

    function getSenderOwner() external view returns(address, address) {
        return (msg.sender, owner);
    }


}
