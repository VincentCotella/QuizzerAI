import 'package:flutter/material.dart';
import 'package:quiz_app/dto/player.dart';
import 'package:quiz_app/stage/abstract_stage.dart';
import 'package:quiz_app/stage/widget/player_card.dart';

import 'package:quiz_app/service/http_service.dart' as http_service;

class WaitingForPlayerStage extends AbstractStage {
  final Player player;

  const WaitingForPlayerStage(super.game, this.player, {super.key});
  
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Code : ${game.code}', style: const TextStyle(fontSize: 30)),
      Expanded(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Joueurs :'),
          ...game.players.map((player) => PlayerCard(player))
        ]
      )),
      if (game.owner.uuid == player.uuid)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 15.0),
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF8E24AA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
          onPressed: () => http_service.startGame(), 
          child: const Text("Commencer le quiz")),
    ],
  );

}
