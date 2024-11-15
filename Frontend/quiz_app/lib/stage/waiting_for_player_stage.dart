import 'package:flutter/material.dart';
import 'package:quiz_app/stage/abstract_stage.dart';
import 'package:quiz_app/dto/game.dart';

class WaitingForPlayerStage extends StatefulWidget {
  final Game game;

  const WaitingForPlayerStage({required this.game, super.key});

  @override
  State<WaitingForPlayerStage> createState() => _WaitingForPlayerStageState();
}

class _WaitingForPlayerStageState extends State<WaitingForPlayerStage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Define a Tween animation for position (Slide Transition)
    _animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0.1)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("En attente des joueurs")),
      body: Center(
        child: SlideTransition(
          position: _animation,
          child: Text(
            "En attente des autres joueurs...",
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
