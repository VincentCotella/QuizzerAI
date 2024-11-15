import 'package:flutter/material.dart';
import 'package:quiz_app/stage/abstract_stage.dart';

class AnswerStage extends AbstractStage {
  const AnswerStage(super.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Réponse")),
      body: ListView.builder(
        itemCount: game.questions[game.currentQuestionIndex].options.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              tileColor: index == selectedOptionIndex
                  ? Colors.green.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.3),
              title: Text(
                game.questions[game.currentQuestionIndex].options[index],
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}
