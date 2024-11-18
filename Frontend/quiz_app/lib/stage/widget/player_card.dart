import 'package:flutter/material.dart';
import 'package:quiz_app/dto/player.dart';

class PlayerCard extends StatelessWidget {
  final Player player;

  const PlayerCard(this.player, {super.key});

  @override
  Widget build(BuildContext context) => Padding(padding: EdgeInsets.all(5), child: Container(
    width: 300,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color.fromARGB( 200,  100 + player.uuid.hashCode % 100,  100 + player.uuid.hashCode % 100,  100 + player.uuid.hashCode % 100)
    ),
    child: Padding(padding: const EdgeInsets.all(5), child: Text(player.name ?? 'Inconnu', style: const TextStyle(fontSize: 20))),
  ));
  
}