import 'package:flutter/material.dart';
import 'package:quiz_app/dto/player.dart';
import 'package:quiz_app/stage/abstract_stage.dart';

class PointsStage extends AbstractStage {
  const PointsStage(super.game, {super.key});

  @override
  Widget build(BuildContext context) {
    var question = game.questions[game.currentQuestionIndex];
    var answer = question.options[question.answer];
    var points = game.points;
    var answers = question.answers;

    var tuples = points.entries.map((e) => [
      game.players.where((p) => e.key == p.uuid).first, 
      e.value,
      answers[e.key]?.point ?? 0
    ]).toList();
    tuples.sort((a, b) => ((a[1] as num) - (b[1] as num)).toInt());  

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Bonne réponse : $answer', style: const TextStyle(fontSize: 25)),
        const SizedBox(height: 20),
        const Text('Points : ', style: TextStyle(fontSize: 25)),

        ...tuples.map((t) => Container(
          height: 50,
          width: 300,
          color: const Color.fromARGB(255, 213, 213, 213),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Text((t[0] as Player).name ?? 'Inconnu', style: const TextStyle(fontSize: 30)),
                Expanded(child: Container()),
                Text('${t[1].toString()} (+${t[2]})', style: const TextStyle(fontSize: 24))
              ],
            )
          ) 
        ))
      ],
    );

  }
}
