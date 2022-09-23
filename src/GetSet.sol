pragma solidity 0.8.15;

contract GetSet {
    bool value;

    function getValue() external view returns(bool) {
        return value;
    }

    function setValue(bool _value) external {
        value = _value;
    }
}
