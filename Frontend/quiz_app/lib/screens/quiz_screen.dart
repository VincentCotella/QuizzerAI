// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:quiz_app/dto/game.dart';
import 'package:quiz_app/stage/game_lounge_stage.dart';
import 'package:websocket_universal/websocket_universal.dart';
import 'dart:convert';

// ignore: must_be_immutable
class QuizScreen extends StatefulWidget {
  Game game;

  QuizScreen({super.key, required this.game});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late IWebSocketHandler<String, String> _channel;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  Future<void> _connectToWebSocket() async {
    const wsUrl = 'wss://192.168.1.170:8543/game/live';
    final textSocketHandler = IWebSocketHandler<String, String>.createClient(wsUrl, SocketSimpleTextProcessor());

    textSocketHandler.incomingMessagesStream.listen((inMsg) {
      print('> "$inMsg"');
      setState(() {
        widget.game = Game.fromJson(jsonDecode(inMsg));
      });
    });

    await textSocketHandler.connect(params: SocketOptionalParams(
      headers: {
        'X-GameCode': widget.game.code,
      },
    ));
  }

  @override
  void dispose() {
    _channel.disconnect("normal"); // Ferme la connexion WebSocket lorsque l'écran est fermé
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = widget.game.state;

    if (state == "GENERATING") {

    }
    else if (state == "WAITING FOR PLAYER") {
      
    }
    else if (state == "STARTING") {

    }
    else if (state == "QUESTION") {

    }
    else if (state == "ANSWERS") {

    }
    else if (state == "POINTS") {

    }
    else if (state == "ENDING") {

    }
  }
}
