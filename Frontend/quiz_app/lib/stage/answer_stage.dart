import 'package:flutter/material.dart';
import 'package:quiz_app/dto/player.dart';
import 'package:quiz_app/stage/abstract_stage.dart';

import 'package:quiz_app/service/http_service.dart' as http_service;
import 'package:quiz_app/stage/widget/player_card.dart';

List<Color> colors = [
  Colors.yellow,
  Colors.blue,
  Colors.red,
  Colors.green
];

class AnswerStage extends AbstractStage {
  final Player player;

  const AnswerStage(super.game, this.player, {super.key});
  
  @override
  Widget build(BuildContext context) {
    var question = game.questions[game.currentQuestionIndex];
    var choice = question.answers[player.uuid]?.choice;

    if (choice == null) {
      var answers = [];

      for (int i = 0 ; i < question.options.length ; i++) {
        answers.add(GestureDetector(
          onTap: () => http_service.answer(i),
          child: Container(
            height: 50,
            alignment: Alignment.center,
            color: colors[i],
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Text(question.options[i], style: const TextStyle(fontSize: 18))
          )
        ));
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(question.question, style: const TextStyle(fontSize: 20)),
          Text("${game.countdown}s", style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 50),
          ...answers
        ],
      );
    }
    else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(question.question, style: const TextStyle(fontSize: 20)),
          Text("${game.countdown}s", style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 10),
          Text('Vous avez répondu : ${question.options[choice]}'),
          const SizedBox(height: 40),
          const Text('En attente des joueurs suivants :'),
          ...game.players.where((player) => !question.answers.containsKey(player.uuid))
                .map((player) => PlayerCard(player))
        ],
      );
    }
  } 
}
