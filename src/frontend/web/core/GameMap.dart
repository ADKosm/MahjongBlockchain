import 'dart:math';

import 'dart:convert';

import 'Tile.dart';

class GameMap {
  List<Tile> field;
  int timestamp;

  GameMap() {
    field = new List();
  }

  void build_from_sceleton(dynamic sceleton) {
    List<String> tilesToSet = _build_tiles();
    field = new List();
    final _random = new Random();
    var raw_map = JSON.decode(sceleton['game_map']);
    raw_map.shuffle(_random);

    while(raw_map.length > 0) {
      dynamic first = raw_map[0];
      print(first);
      print(raw_map);

      while(!_check_possibility(first[0], first[1], first[2])) {
        first = raw_map[_random.nextInt(raw_map.length)];
      }
      raw_map.remove(first);

      field.add(new Tile(first[0], first[1], first[2], tilesToSet[0]));
      tilesToSet.removeAt(0);
    }
    timestamp = 1;
  }

  void build_from_json(dynamic data) {
    timestamp = data['timestamp'];
    field = new List();
    for(dynamic d in data['game_map']) {
      field.add(new Tile(d[0], d[1], d[2], d[3]));
    }
  }

  dynamic to_json() {
    var result = new List();
    for(Tile t in field) {
      result.add([t.x, t.y, t.z, t.type]);
    }
    return JSON.encode(result);
  }

  bool _check_possibility(int x, int y, int z) {
    int higher = 0;
    int lower = 0;
    for(Tile t in field) {
      if(t.x == x && t.y == y && t.z < z) lower++;
      if(t.x == x && t.y == y && t.z > z) higher++;
    }
    return (lower == z && higher == 0);
  }

  List<String> _build_tiles() {
    List<String> result = new List();

    for(int i = 1; i < 10; i++) {
      for(int j = 0; j < 4; j++) result.add("bamboo${i}");
    }
    for(int i = 1; i < 10; i++){
      for(int j = 0; j < 4; j++) result.add("circle${i}");
    }
    for(int i = 1; i < 16; i++) {
      for(int j = 0; j < 4; j++) result.add("pinyin${i}");
    }

    result.add("chrysanthemum");
    result.add("lotus");
    result.add("orchid");
    result.add("peony");

    result.add("fall");
    result.add("spring");
    result.add("summer");
    result.add("winter");

    return result;
  }
}