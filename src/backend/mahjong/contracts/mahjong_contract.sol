pragma solidity ^0.4.0;

contract Greeter {
    string public greeting;
    string public index;

    function Greeter() {
        greeting = 'Hello';
        index = 'B-tree';
    }

    function setGreeting(string _greeting) public {
        greeting = _greeting;
    }

    function setIndex(string _index) public {
        index = _index;
    }

    function greet() constant returns (string) {
        return greeting;
    }

    function index() constant returns (string) {
        return index;
    }
}