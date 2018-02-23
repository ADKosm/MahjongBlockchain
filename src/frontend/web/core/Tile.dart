import 'package:stagexl/stagexl.dart';

import 'GameMap.dart';

class Tile {
  int x, y, z;
  String type;
  Sprite sprite;
  GameMap gameMap;

  Tile(int _x, int _y, int _z, String t, GameMap map) {
    x = _x;
    y = _y;
    z = _z;
    type = t;
    gameMap = map;
  }

  bool match_with(Tile other) {
    var flowers = ["chrysanthemum", "lotus", "orchid", "peony"];
    var seasons = ["fall", "spring", "summer", "winter"];
    if(flowers.contains(type)) {
      return flowers.contains(other.type);
    }
    if(seasons.contains(type)) {
      return seasons.contains(other.type);
    }
    return (type == other.type);
  }
}