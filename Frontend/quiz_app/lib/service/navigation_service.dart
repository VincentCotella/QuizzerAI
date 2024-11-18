import 'package:flutter/material.dart';
import 'package:quiz_app/dto/game.dart';
import 'package:quiz_app/dto/player.dart';

void goToGame(BuildContext context, Game game, Player player) {
  Navigator.pushNamed(context, "/game", arguments: [game, player]);
}