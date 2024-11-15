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

import 'package:quiz_app/service/ws_service.dart' as ws_service;

// ignore: must_be_immutable
class QuizScreen extends StatefulWidget {
  Game game;

  QuizScreen(this.game, {super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late IWebSocketHandler<String, String> _channel;

  @override
  Future<void> initState() async {
    super.initState();

    _channel = ws_service.listenGame(widget.game.code, (game) => setState(() {
      widget.game = game;
    }));
  }

  @override
  void dispose() {
    _channel.disconnect("normal");
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
