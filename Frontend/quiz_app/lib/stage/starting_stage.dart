import 'package:flutter/material.dart';
import 'package:quiz_app/stage/abstract_stage.dart';

class StartingStage extends AbstractStage {
  const StartingStage(super.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Début du jeu")),
      body: Center(
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.2).animate(
            CurvedAnimation(
              parent: AnimationController(
                duration: const Duration(seconds: 1),
                vsync: this,
              )..repeat(reverse: true),
              curve: Curves.easeInOut,
            ),
          ),
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
