// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiCall {
    function multiCall(address[] calldata targets, bytes[] calldata data)
        external
        view
        returns (bytes[] memory)
    {
        require(targets.length == data.length, "not same length");
        bytes[] memory results = new bytes[](data.length);
        
        for (uint i; i < targets.length; i++) {
            
            bool success; 
            (success, results[i]) = targets[i].staticcall(data[i]);
            require(success);
            
        }
        

        return results;
    }
}
