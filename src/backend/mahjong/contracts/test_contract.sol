pragma solidity ^0.4.0;

contract Mahjong {
    mapping (bytes32 => int) public timestamp;
    int b;

    function setTimestamp(bytes32 id, int value) public {
        timestamp[id] = value;
    }

    function setNum(int h) public {
        b = h;
    }

    function getNum() constant returns (int) {
        return b;
    }

    function getTimestamp(bytes32 id) constant returns (int) {
        return timestamp[id];
    }
}