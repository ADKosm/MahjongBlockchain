import 'dart:html';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'GameMap.dart';

class Gateway {
  String sessionId;

  void connect_session_id(String id) {
    sessionId = id;
  }

  Future<dynamic> new_game() async {
    var req = await HttpRequest.request("/api/new_game", method: 'POST');
    var id = JSON.decode(req.responseText)['game_id'];
    return id;
  }

  Future<Null> step(GameMap map) async {
    var postData = {
      'game_id': sessionId,
      'new_map': map.to_json()
    };

    await HttpRequest.postFormData("/api/step", postData);
    map.timestamp++;
  }

  void sync_step(GameMap map) {
    var postData = {
      'game_id': sessionId,
      'new_map': map.to_json()
    };

    HttpRequest.postFormData("/api/step", postData).then((HttpRequest s) {
      print("Commit step");
    });
    map.timestamp++;
  }

  Future<Null> back_to(int timestamp) async {
    print("Hello, this is ${timestamp}");
    var postData = {
      'game_id': sessionId,
      'step_timestamp': timestamp.toString()
    };

    await HttpRequest.postFormData("/api/back_to", postData);
  }

  Future<dynamic> get_current() async {
    var postData = {
      'game_id': sessionId
    };
    var req = await HttpRequest.postFormData("/api/get_current", postData);

    var result = JSON.decode(req.responseText);
    return result;
  }
}