import 'package:flutter/material.dart';
import 'package:quiz_app/dto/game.dart'; // Ensure this is imported if needed

class StartingStage extends StatefulWidget {
  final Game game;

  const StartingStage({required this.game, super.key});

  @override
  State<StartingStage> createState() => _StartingStageState();
}

class _StartingStageState extends State<StartingStage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this, // `vsync` is provided by SingleTickerProviderStateMixin
    )..repeat(reverse: true);

    // Define a Tween animation for scale
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Début du jeu")),
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Text(
            "Le jeu commence!",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
