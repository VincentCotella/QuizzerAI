import 'package:flutter/material.dart';
import 'package:quiz_app/dto/game.dart';

void goToGame(BuildContext context, Game game) {
  Navigator.pushNamed(context, "/game", arguments: game);
}