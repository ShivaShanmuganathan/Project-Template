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


// Why use Multi Delegate Call ?
// It carries the context: Example -> msg.sender calls func1 in contract1, which calls func2 in contract2 .
// Now, the msg.sender for func2 will still be OG msg.sender, and not contract1