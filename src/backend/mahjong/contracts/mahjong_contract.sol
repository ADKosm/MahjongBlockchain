pragma solidity ^0.4.0;

contract Mahjong {
    mapping (bytes32 => int) public timestamp;
    mapping (bytes32 => string) public game_map;

    function injectStep(bytes32 id, string map, int time) public {
        timestamp[id] = time;
        game_map[id] = map;
    }

    function commitStep(bytes32 id, string map) public {
        int current_timestamp = timestamp[id];
        timestamp[id] = current_timestamp + 1;
        game_map[id] = map;
    }

    function getTimestamp(bytes32 id) constant returns (int) {
        return timestamp[id];
    }

    function getGameMap(bytes32 id) constant returns (string) {
        return game_map[id];
    }
}