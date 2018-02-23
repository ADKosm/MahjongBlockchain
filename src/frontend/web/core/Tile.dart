import 'package:stagexl/stagexl.dart';

class Tile {
  int x, y, z;
  String type;
  Sprite sprite;

  Tile(int _x, int _y, int _z, String t) {
    x = _x;
    y = _y;
    z = _z;
    type = t;
  }

  bool match_with(Tile other) {
    return true;
  }
}