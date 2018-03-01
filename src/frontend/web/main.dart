import 'dart:async';

import 'core/GameController.dart';

Future<Null> main() async {
  GameController controller = new GameController();
  await controller.boot_application();

  await controller.new_game();
}
