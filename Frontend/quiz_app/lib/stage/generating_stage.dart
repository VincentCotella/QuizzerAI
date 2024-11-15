import 'package:flutter/material.dart';
import 'package:quiz_app/stage/abstract_stage.dart';

class GeneratingStage extends AbstractStage {
  const GeneratingStage(super.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: AnimationController(
                duration: const Duration(seconds: 2),
                vsync: this,
              )..repeat(reverse: true),
              curve: Curves.easeInOut,
            ),
          ),
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
