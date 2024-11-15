import 'package:flutter/material.dart';
import 'package:quiz_app/dto/game.dart';

abstract class AbstractStage extends StatelessWidget {
  final Game game;

  const AbstractStage(this.game, {super.key});
}