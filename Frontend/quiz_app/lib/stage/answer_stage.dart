import 'package:flutter/material.dart';
import 'package:quiz_app/dto/game.dart';

class AnswerStage extends StatefulWidget {
  final Game game; // Define `game` here as a final property

  const AnswerStage(this.game, {Key? key}) : super(key: key); // Pass `game` in the constructor

  @override
  State<AnswerStage> createState() => _AnswerStageState();
}

class _AnswerStageState extends State<AnswerStage> {
  int selectedOptionIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Réponse")),
      body: ListView.builder(
        itemCount: widget.game.questions[widget.game.currentQuestionIndex].options.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedOptionIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                tileColor: index == selectedOptionIndex
                    ? Colors.green.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.3),
                title: Text(
                  widget.game.questions[widget.game.currentQuestionIndex].options[index],
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
