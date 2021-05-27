//Hadcoins ICO

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.0;

contract TodoList{
    
    uint public taskCount;
    
    struct Task{
        string taskName;
        bool isCompleted;
    }

    
    
    mapping(uint => Task) public todos;
    
    event TaskCreated(string task, uint taskNumber);
    
    constructor() public {
        todos[0] = Task("test", true); 
        taskCount = 1;
    }
    
    
    function createTask(string memory _taskName) public{
        todos[taskCount++] = Task(_taskName, false);
        emit TaskCreated(_taskName, taskCount - 1);
    }
    
}