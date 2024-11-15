import 'package:flutter/material.dart';
import 'package:quiz_app/stage/abstract_stage.dart';

class QuestionStage extends AbstractStage {
  const QuestionStage(super.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Question")),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Column(
            key: ValueKey(game.currentQuestionIndex),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                game.questions[game.currentQuestionIndex].question,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Code d'affichage des options de réponse ici
            ],
          ),
        ),
      ),
    );
  }
}
