// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MultiDelegatecall {
    function multiDelegatecall(bytes[] calldata data)
        external
        payable
        returns (bytes[] memory results)
    {
        
        results = new bytes[](data.length);
        
        for(uint i; i < data.length; i++){
            
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);
            require(success);
            results[i] = result;
            
        }
        
    }
}

contract TestMultiDelegatecall is MultiDelegatecall{
    event Log(address caller, string func, uint i);

    function func1(uint x, uint y) external {
        emit Log(msg.sender, "func1", x + y);
    }

    function func2() external returns (uint) {
        emit Log(msg.sender, "func2", 2);
        return 111;
    }
}
