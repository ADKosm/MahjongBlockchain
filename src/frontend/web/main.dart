import 'dart:async';

import 'core/GameController.dart';

Future<Null> main() async {
  GameController controller = new GameController();
  await controller.boot_application();

  await controller.new_game();


//  var bamboos = new List();
//  for(int i = 1; i < 10; i++) {
//    var bamboo = new Sprite();
//    bamboo.addChild(new Bitmap(resourceManager.getBitmapData("bamboo${i}")));
//    bamboo.width = 64;
//    bamboo.height = 90;
//    bamboos.add(bamboo);
//  }
//
//  for(int i = 8; i >= 0; i--) {
//    stage.addChild(bamboos[i]);
//  }
//
//  for(int i = 0; i < 9; i++) {
//    bamboos[i].x = i * (64 - 9);
//    bamboos[i].y = 64;
//  }
//
//  for(int i = 0; i < 9; i++) {
//    bamboos[i].onMouseClick.listen((MouseEvent e) {
//      print(i);
//      stage.removeChild(bamboos[i]);
//    });
//  }

//  var logo = new Sprite();
//  logo.addChild(new Bitmap(logoData));
//
//  logo.pivotX = logoData.width / 2;
//  logo.pivotY = logoData.height / 2;
//
//  // Place it at top center.
//  logo.x = 1280 / 2;
//  logo.y = 0;
//
//  stage.addChild(logo);

  // And let it fall.
//  var tween = stage.juggler.addTween(logo, 3, Transition.easeOutBounce);
//  tween.animate.y.to(800 / 2);

  // Add some interaction on mouse click.
//  Tween rotation;
//  logo.onMouseClick.listen((MouseEvent e) {
//    // Don't run more rotations at the same time.
//    if (rotation != null) return;
//    rotation = stage.juggler.addTween(logo, 0.5, Transition.easeInOutCubic);
//    rotation.animate.rotation.by(2 * PI);
//    rotation.onComplete = () => rotation = null;
//  });
//  logo.mouseCursor = MouseCursor.POINTER;

  // See more examples:
  // https://github.com/bp74/StageXL_Samples
}
