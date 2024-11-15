import 'package:flutter/material.dart';
import 'package:quiz_app/stage/abstract_stage.dart';
import 'package:quiz_app/dto/game.dart'; 

class GeneratingStage extends StatefulWidget {
  final Game game; // Define `game` as a final property of GeneratingStage

  const GeneratingStage({required this.game, super.key}); // Make `game` a required named parameter

  @override
  State<GeneratingStage> createState() => _GeneratingStageState();
}

class _GeneratingStageState extends State<GeneratingStage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this, // Using `vsync` here to prevent offscreen animations
    )..repeat(reverse: true);

    // Define a Tween animation for opacity
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Text(
            "Génération des questions en cours...",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
