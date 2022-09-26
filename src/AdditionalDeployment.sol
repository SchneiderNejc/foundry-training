pragma solidity 0.8.15;

contract AdditionalDeployment {
    uint number;
    address owner;

    constructor(uint _number, address _owner){
        require(_number > 0, "number cant be 0");
        require(_owner != address(0), "invalid address");
        number = _number;
        owner = _owner;
    }

    function getOwner() external view returns(address){
        return owner;
    }
}
