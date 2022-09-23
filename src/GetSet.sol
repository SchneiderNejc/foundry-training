pragma solidity 0.8.15;

contract GetSet {

    bool value;
    uint public identifier = 10;
    uint[] public values = [identifier, 4, 3, 2, 1];

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
}
