import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'GameController.dart';
import 'Tile.dart';

class GameMap {
  List<Tile> field;
  int timestamp;

  GameController gameController;
  Tile underCursor;

  GameMap(GameController controller) {
    field = new List();
    underCursor = null;
    gameController = controller;
  }

  void build_from_sceleton(dynamic sceleton) {
    List<String> tilesToSet = _build_tiles();
    field = new List();
    final _random = new Random();
    var raw_map = JSON.decode(sceleton['game_map']);
    raw_map.shuffle(_random);

    while(raw_map.length > 0) {
      dynamic first = raw_map[0];
      while(!_check_possibility(first[0], first[1], first[2])) {
        first = raw_map[_random.nextInt(raw_map.length)];
      }
      raw_map.remove(first);

      dynamic second = raw_map[0];
      while(!_check_possibility(second[0], second[1], second[2])) {
        second = raw_map[_random.nextInt(raw_map.length)];
      }
      raw_map.remove(second);

      field.add(new Tile(first[0], first[1], first[2], tilesToSet[0], this));
      field.add(new Tile(second[0], second[1], second[2], tilesToSet[1], this));
      tilesToSet.removeAt(0);
      tilesToSet.removeAt(0);
    }
    timestamp = 0;
  }

  void reset_cursor() {
    gameController.unrender_cursor(underCursor);
    underCursor = null;
  }

  void set_cursor(Tile newCursor) {
    underCursor = newCursor;
    gameController.render_cursor(underCursor);
  }

  Future<Null> match_tile(Tile tile) async {
    if(!_check_possibility(tile.x, tile.y, tile.z)) return;

    if(underCursor == null) {
      set_cursor(tile);
    } else if(underCursor == tile) {
      reset_cursor();
    } else {
      if(underCursor.match_with(tile)) {
        field.remove(tile);
        field.remove(underCursor);

        gameController.remove_tile(tile);
        gameController.remove_tile(underCursor);

        reset_cursor();

        gameController.commit_step();
      } else {
        reset_cursor();
        set_cursor(tile);
      }
    }
  }

  void build_from_json(dynamic data) {
    timestamp = data['timestamp'];
    field = new List();
    var map = JSON.decode(data['game_map']);

    for(dynamic d in map) {
      field.add(new Tile(d[0], d[1], d[2], d[3], this));
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