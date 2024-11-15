import 'package:flutter/material.dart';
import 'package:quiz_app/stage/abstract_stage.dart';

class WaitingForPlayerStage extends AbstractStage {
  const WaitingForPlayerStage(super.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("En attente des joueurs")),
      body: Center(
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0, 0))
              .animate(
            CurvedAnimation(
              parent: AnimationController(
                duration: const Duration(seconds: 1),
                vsync: this,
              )..repeat(reverse: true),
              curve: Curves.easeInOut,
            ),
          ),
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
