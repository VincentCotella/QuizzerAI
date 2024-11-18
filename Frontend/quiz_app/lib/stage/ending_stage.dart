import 'package:flutter/material.dart';
import 'package:quiz_app/stage/abstract_stage.dart';

import 'package:quiz_app/service/http_service.dart' as http_service;

class EndingStage extends AbstractStage {
  const EndingStage(super.game, {super.key});

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = game.points.entries.toList()
      .map((e) => MapEntry(game.players.where((p) => p.uuid == e.key).first.name ?? 'Inconnu', e.value))
      .toList();

    sortedPlayers.sort((a, b) => b.value.compareTo(a.value));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "🏆 Classement Final 🏆",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          SizedBox(height: 20),
          _buildPodium(context, sortedPlayers),
          SizedBox(height: 30),
          _buildPlayerList(sortedPlayers),
          SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              onPressed: () {
                http_service.leaveGame();
                Navigator.pushNamed(context, "/");
              },
              child: Text("Retour à l'accueil", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(BuildContext context, List<MapEntry<String, double>> sortedPlayers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (sortedPlayers.length > 1)
          _buildPodiumTile(
            context,
            sortedPlayers[1].key,
            sortedPlayers[1].value,
            2,
            Colors.grey[400],
          ),
        if (sortedPlayers.isNotEmpty)
          _buildPodiumTile(
            context,
            sortedPlayers[0].key,
            sortedPlayers[0].value,
            1,
            Colors.yellow[700],
          ),
        if (sortedPlayers.length > 2)
          _buildPodiumTile(
            context,
            sortedPlayers[2].key,
            sortedPlayers[2].value,
            3,
            Colors.brown[400],
          ),
      ],
    );
  }

  Widget _buildPodiumTile(BuildContext context, String playerName, double score, int position, Color? color) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.easeOut,
          width: 70,
          height: position == 1 ? 120 : (position == 2 ? 100 : 80),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$position",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                playerName,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                "${score.toInt()} pts",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerList(List<MapEntry<String, double>> sortedPlayers) {
    return Column(
      children: sortedPlayers
          .skip(3) // Ignorer les 3 premiers pour le podium
          .map((entry) => ListTile(
                leading: Icon(Icons.person, color: Colors.blueAccent),
                title: Text(
                  entry.key,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  "${entry.value.toInt()} pts",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ))
          .toList(),
    );
  }
}
