import 'dart:convert';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:quiz_app/service/http_service.dart';

import 'package:quiz_app/dto/game.dart';

WebSocket listenGame(int gameCode, void Function(Game) callback) {
  const wsUrl = 'wss://$baseUrl/game/live';

  var socket = WebSocket(Uri.parse(wsUrl));

  socket.messages.listen((msg) {
    callback(Game.fromJson(jsonDecode(msg)));
  });

  socket.connection.listen((event) {
    if (event is Connected) {
      socket.send(gameCode.toString());
    }
  });

  return socket;
}