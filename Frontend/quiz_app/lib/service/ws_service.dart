import 'dart:convert';

import 'package:quiz_app/dto/game.dart';
import 'package:websocket_universal/websocket_universal.dart';

import 'package:quiz_app/service/http_service.dart' as http_service;

IWebSocketHandler<String, String> listenGame(int gameCode, void Function(Game) callback) {
  const wsUrl = 'wss://${http_service.baseUrl}/game/live';
  final textSocketHandler = IWebSocketHandler<String, String>.createClient(wsUrl, SocketSimpleTextProcessor());

  textSocketHandler.incomingMessagesStream.listen((inMsg) {
    print('> "$inMsg"');
    callback(Game.fromJson(jsonDecode(inMsg)));
  });

  textSocketHandler.connect(params: SocketOptionalParams(
    headers: {
      'X-GameCode': gameCode,
    },
  ));

  return textSocketHandler;
}