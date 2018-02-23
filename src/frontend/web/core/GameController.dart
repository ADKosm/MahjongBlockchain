import 'dart:async';
import 'dart:html' as html;

import 'package:stagexl/stagexl.dart';

import 'GameMap.dart';
import 'Gateway.dart';
import 'Tile.dart';

class GameController {
  RenderLoop renderLoop;
  Stage stage;
  ResourceManager resourceManager;

  Gateway gateway;
  GameMap gameMap;
  String gameId;

  int x_size;
  int y_size;
  int screen_x;
  int screen_y;
  int padding_x;
  int padding_y;


  Future<Null> boot_application() async {
    x_size = 55;
    y_size = 81;
    screen_x = 1280;
    screen_y = 800;
    padding_x = 64;
    padding_y = 60;

    StageOptions options = new StageOptions()
      ..backgroundColor = Color.LightGreen
      ..renderEngine = RenderEngine.WebGL;

    var canvas = html.querySelector('#stage');
    stage = new Stage(canvas, width: screen_x, height: screen_y, options: options);
    stage.scaleMode = StageScaleMode.SHOW_ALL;
    stage.align = StageAlign.NONE;

    resourceManager = new ResourceManager();
    await _load_tiles();

    renderLoop = new RenderLoop();
    renderLoop.addStage(stage);

    gateway = new Gateway();
    gameMap = new GameMap(this);

    var plate = new GlassPlate(screen_x, screen_y);
    plate.onMouseClick.listen((MouseEvent e){
      gameMap.reset_cursor();
    });
    stage.addChild(plate);
  }

  Future<Null> new_game() async {
    gameId = await gateway.new_game();
    gateway.connect_session_id(gameId);

    var gameSceleton = await gateway.get_current();
    gameMap.build_from_sceleton(gameSceleton);

    await gateway.step(gameMap);
    render_field();
  }

  void back_to() {}

  Future<Null> _load_tiles() async {
    for(int i = 1; i < 10; i++) { // load bamboos
      resourceManager.addBitmapData(
          "bamboo${i}", "images/fulltiles/bamboo${i}.png");
    }

    for(int i = 1; i < 10; i++){ // load circles
      resourceManager.addBitmapData(
          "circle${i}", "images/fulltiles/circle${i}.png");
    }

    for(int i = 1; i < 16; i++) { // load pinyins
      resourceManager.addBitmapData(
          "pinyin${i}", "images/fulltiles/pinyin${i}.png");
    }

    // load flowers
    resourceManager.addBitmapData(
        "chrysanthemum", "images/fulltiles/chrysanthemum.png");
    resourceManager.addBitmapData(
        "lotus", "images/fulltiles/lotus.png");
    resourceManager.addBitmapData(
        "orchid", "images/fulltiles/orchid.png");
    resourceManager.addBitmapData(
        "peony", "images/fulltiles/peony.png");

    // load seasons
    resourceManager.addBitmapData("fall", "images/fulltiles/fall.png");
    resourceManager.addBitmapData("spring", "images/fulltiles/spring.png");
    resourceManager.addBitmapData("summer", "images/fulltiles/summer.png");
    resourceManager.addBitmapData("winter", "images/fulltiles/winter.png");

    await resourceManager.load();
  }

  void render_field() {
    gameMap.field.sort((Tile t1, Tile t2) {
      if(t1.x != t2.x) return t2.x - t1.x;
      if(t1.y != t2.y) return t1.y - t2.y;
      return t1.z - t2.z;
    });
    for(Tile t in gameMap.field) {
      t.sprite = new Sprite();
      t.sprite.addChild(new Bitmap(resourceManager.getBitmapData(t.type)));

      t.sprite.x = t.x * x_size + padding_x + t.z * 9;
      t.sprite.y = t.y * y_size + padding_y - t.z * 9;

      t.sprite.width = 64;
      t.sprite.height = 90;

      t.sprite.onMouseClick.listen((MouseEvent e) {
        gameMap.match_tile(t);
      });

      stage.addChild(t.sprite);
    }
  }

  void render_cursor(Tile tile) {
    tile.sprite.x = tile.x * x_size + padding_x + (tile.z + 1) * 9;
    tile.sprite.y = tile.y * y_size + padding_y - (tile.z + 1) * 9;
  }

  void unrender_cursor(Tile tile) {
    tile.sprite.x = tile.x * x_size + padding_x + tile.z * 9;
    tile.sprite.y = tile.y * y_size + padding_y - tile.z * 9;
  }

  void remove_tile(Tile tile) {
    stage.removeChild(tile.sprite);
  }
}