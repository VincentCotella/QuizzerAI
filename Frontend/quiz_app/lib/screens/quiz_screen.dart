// lib/screens/quiz_screen.dart
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:quiz_app/dto/game.dart';
import 'package:quiz_app/stage/answer_stage.dart';
import 'package:quiz_app/stage/ending_stage.dart';
import 'package:quiz_app/stage/generating_stage.dart';
import 'package:quiz_app/stage/point_stage.dart';
import 'package:quiz_app/stage/question_stage.dart';
import 'package:quiz_app/stage/starting_stage.dart';
import 'package:quiz_app/stage/waiting_for_player_stage.dart';
import 'package:websocket_universal/websocket_universal.dart';
import 'dart:convert';

// ignore: must_be_immutable
class QuizScreen extends StatefulWidget {
  late Game game;

  QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late IWebSocketHandler<String, String> _channel;

  @override
  Future<void> initState() async {
    super.initState();

    var d = await http.get(Uri.parse('https://192.168.1.170:8543/game'));
    widget.game = Game.fromJson(jsonDecode(d.body));
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
      return GeneratingStage(game: widget.game);
    }
    else if (state == "WAITING FOR PLAYER") {
      return WaitingForPlayerStage(game: widget.game);
    }
    else if (state == "STARTING") {
      return StartingStage(game: widget.game);
    }
    else if (state == "QUESTION") {
      return QuestionStage(widget.game);
    }
    else if (state == "ANSWERS") {
      return AnswerStage(widget.game);
    }
    else if (state == "POINTS") {
      return PointsStage(widget.game);
    }
    else if (state == "ENDING") {
      return EndingStage(widget.game);
    }

    return const Text("Unknown stage");
  }
}
