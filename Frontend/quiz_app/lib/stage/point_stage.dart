import 'package:flutter/material.dart';
import 'package:quiz_app/stage/abstract_stage.dart';

class PointsStage extends AbstractStage {
  const PointsStage(super.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Points")),
      body: Center(
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(seconds: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: game.points.entries.map((entry) {
              return Text(
                "${entry.key}: ${entry.value} points",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
