import 'package:flutter/material.dart';
import 'package:quiz_app/dto/player.dart';
import 'package:quiz_app/stage/abstract_stage.dart';
import 'package:quiz_app/stage/widget/player_card.dart';

import 'package:quiz_app/service/http_service.dart' as http_service;

class WaitingForPlayerStage extends AbstractStage {
  final Player player;

  const WaitingForPlayerStage(super.game, this.player, {super.key});
  
  @override
  Widget build(BuildContext context) {
    // Obtenir la taille de l'écran pour la responsivité
    final Size screenSize = MediaQuery.of(context).size;

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
      child: Center(
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.white.withOpacity(0.9),
          margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icône animée sans rotation
                Icon(
                  Icons.group,
                  size: 80.0,
                  color: const Color(0xFF6A1B9A),
                ),
                const SizedBox(height: 20.0),
                // Code du jeu dans une boîte avec fond gris
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300, // Fond gris
                    borderRadius: BorderRadius.circular(10.0), // Bordures arrondies
                  ),
                  child: Text(
                    'Code : ${game.code}',
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                // Liste des joueurs avec style amélioré
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Joueurs :',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8E24AA),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      // Utilisation d'un ListView pour permettre le défilement si nécessaire
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: game.players.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: PlayerCard(game.players[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                // Bouton pour commencer le quiz avec style amélioré
                if (game.owner.uuid == player.uuid)
                  ElevatedButton(
                    onPressed: () => http_service.startGame(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15.0),
                      backgroundColor: const Color(0xFFFFC107),
                      foregroundColor: const Color(0xFF6A1B9A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 5.0,
                      shadowColor: Colors.black45,
                    ),
                    child: const Text(
                      "Commencer le quiz",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
