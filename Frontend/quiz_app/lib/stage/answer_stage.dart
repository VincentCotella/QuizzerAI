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

    return Container(
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
            child: choice == null ? _buildAnswerOptions(question) : _buildAnsweredState(question, choice),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(var question) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Question Text
        Text(
          question.question,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A1B9A),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Countdown Timer
        Text(
          "${game.countdown}s",
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A1B9A),
          ),
        ),
        const SizedBox(height: 30),
        // Answer Options
        ...List.generate(question.options.length, (i) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () => http_service.answer(i),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors[i],
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5.0,
              ),
              child: Text(
                question.options[i],
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAnsweredState(var question, int choice) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Question Text
        Text(
          question.question,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A1B9A),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Countdown Timer
        Text(
          "${game.countdown}s",
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A1B9A),
          ),
        ),
        const SizedBox(height: 10),
        // User's Choice
        Text(
          'Vous avez répondu : ${question.options[choice]}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8E24AA),
          ),
        ),
        const SizedBox(height: 40),
        // Waiting for Other Players
        const Text(
          'En attente des joueurs suivants :',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8E24AA),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        // List of Players Awaiting Response
        ...game.players
            .where((player) => !question.answers.containsKey(player.uuid))
            .map((player) => PlayerCard(player))
            .toList(),
      ],
    );
  }
}
