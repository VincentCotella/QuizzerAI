import 'package:flutter/material.dart';
import 'package:quiz_app/stage/abstract_stage.dart';
import 'package:quiz_app/service/http_service.dart' as http_service;

class EndingStage extends AbstractStage {
  const EndingStage(super.game, {super.key});

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = game.points.entries.toList()
      .map((e) => MapEntry(
          game.players.where((p) => p.uuid == e.key).first.name ?? 'Inconnu', e.value))
      .toList();

    sortedPlayers.sort((a, b) => b.value.compareTo(a.value));

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6A1B9A), // Couleur primaire
            Color(0xFF8E24AA), // Couleur secondaire
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Titre Principal
            Text(
              "🏆 Classement Final 🏆",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Couleur harmonisée avec le dégradé
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black45,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            
            // Podium
            _buildPodium(context, sortedPlayers),
            SizedBox(height: 30),
            
            // Liste des Joueurs
            Expanded(
              child: _buildPlayerList(sortedPlayers),
            ),
            SizedBox(height: 40),
            
            // Bouton de Retour à l'Accueil
            Center(
              child: ElevatedButton(
                onPressed: () {
                  http_service.leaveGame();
                  Navigator.pushNamed(context, "/");
                },
                child: Text(
                  "Retour à l'accueil",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                  backgroundColor: Colors.white, // Couleur cohérente avec le thème
                  foregroundColor: Color(0xFF6A1B9A), // Texte en couleur primaire
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5.0,
                  shadowColor: Colors.black45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodium(BuildContext context, List<MapEntry<String, double>> sortedPlayers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (sortedPlayers.length > 1)
          _buildPodiumTile(
            sortedPlayers[1].key,
            sortedPlayers[1].value,
            2,
            Colors.grey.shade400!,
          ),
        if (sortedPlayers.isNotEmpty)
          _buildPodiumTile(
            sortedPlayers[0].key,
            sortedPlayers[0].value,
            1,
            Colors.yellow.shade700!,
          ),
        if (sortedPlayers.length > 2)
          _buildPodiumTile(
            sortedPlayers[2].key,
            sortedPlayers[2].value,
            3,
            Colors.brown.shade400!,
          ),
      ],
    );
  }

  Widget _buildPodiumTile(String playerName, double score, int position, Color color) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.easeOut,
          width: 80,
          height: position == 1 ? 120 : (position == 2 ? 100 : 80),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$position",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                playerName,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "${score.toInt()} pts",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerList(List<MapEntry<String, double>> sortedPlayers) {
    return ListView.builder(
      itemCount: sortedPlayers.length - 3 < 0 ? 0 : sortedPlayers.length - 3,
      itemBuilder: (context, index) {
        final entry = sortedPlayers[index + 3];
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8), // Fond semi-transparent
            borderRadius: BorderRadius.circular(12.0), // Bordures arrondies
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.person, color: Color(0xFF6A1B9A)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
              ),
              Text(
                "${entry.value.toInt()} pts",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
