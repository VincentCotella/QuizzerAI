import 'package:flutter/material.dart';
import 'package:quiz_app/stage/abstract_stage.dart';

class QuestionStage extends AbstractStage {
  const QuestionStage(super.game, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A1B9A), // Couleur primaire
              Color(0xFF8E24AA), // Couleur secondaire
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.white.withOpacity(0.9),
            margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Column(
                  key: ValueKey(game.currentQuestionIndex),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      game.questions[game.currentQuestionIndex].question,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A1B9A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
