import 'dart:convert';
import 'dart:io';

import 'package:quiz_app/dto/game.dart';

const String baseUrl = "127.0.0.1:8544";

Future<WebSocket> listenGame(int gameCode, void Function(Game) callback) {
  const wsUrl = 'ws://$baseUrl/game/live';

  var future = WebSocket.connect(wsUrl, headers: {
    'X-GameCode': gameCode
  });

  future.then((socket) {
    socket.listen((event) {
      callback(Game.fromJson(jsonDecode(event)));
    });
  });
  
  return future;
}