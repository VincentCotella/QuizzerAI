import 'package:flutter/material.dart';
import 'package:quiz_app/dto/game.dart';
import 'package:quiz_app/dto/player.dart';
import 'package:quiz_app/stage/answer_stage.dart';
import 'package:quiz_app/stage/ending_stage.dart';
import 'package:quiz_app/stage/generating_stage.dart';
import 'package:quiz_app/stage/point_stage.dart';
import 'package:quiz_app/stage/question_stage.dart';
import 'package:quiz_app/stage/starting_stage.dart';
import 'package:quiz_app/stage/waiting_for_player_stage.dart';
import 'package:web_socket_client/web_socket_client.dart';

import 'package:quiz_app/service/ws_service.dart' as ws_service;
import 'package:quiz_app/service/http_service.dart' as http_service;

// ignore: must_be_immutable
class QuizScreen extends StatefulWidget {
  Game game;
  Player player;

  QuizScreen(this.game, this.player, {super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late WebSocket _socket;

  @override
  void initState() {
    super.initState();

    _socket = ws_service.listenGame(widget.game.code, (game) => setState(() {
      widget.game = game;
    }));
  }

  @override
  void dispose() {
    _socket.close();
    super.dispose();
  }

  Widget content() {
    var state = widget.game.state;

    if (state == "GENERATING") {
      return GeneratingStage(game: widget.game);
    }
    else if (state == "WAITING_FOR_PLAYER") {
      return WaitingForPlayerStage(widget.game, widget.player);
    }
    else if (state == "STARTING") {
      return StartingStage(game: widget.game);
    }
    else if (state == "QUESTION") {
      return QuestionStage(widget.game);
    }
    else if (state == "ANSWERS") {
      return AnswerStage(widget.game, widget.player);
    }
    else if (state == "POINTS") {
      return PointsStage(widget.game);
    }
    else if (state == "ENDING") {
      return EndingStage(widget.game);
    }

    return const Text("Unknown stage");
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(onPressed: () {
        http_service.leaveGame();
        Navigator.pushNamed(context, "/");
      }, icon: const Icon(Icons.arrow_back)),
      title: Text("${widget.game.theme} - ${widget.game.difficulty.label}"),
    ),
    body: Center(child: content()),
  );
}
