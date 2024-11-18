import 'package:flutter/material.dart';
import 'package:quiz_app/dto/player.dart';
import 'package:quiz_app/stage/abstract_stage.dart';

class PointsStage extends AbstractStage {
  const PointsStage(super.game, {super.key});

  @override
  Widget build(BuildContext context) {
    var question = game.questions[game.currentQuestionIndex];
    var answer = question.options[question.answer];
    var points = game.points;
    var answers = question.answers;

    // Créer une Map pour une recherche rapide des joueurs par UUID
    Map<String, Player> playerMap = { for (var p in game.players) p.uuid: p };

    // Créer une liste de tuples [Player, points, bonus points]
    var tuples = points.entries.map((e) {
      var player = playerMap[e.key];
      if (player != null && player.name != null && player.name!.isNotEmpty) {
        return [
          player,
          e.value,
          answers[e.key]?.point ?? 0,
        ];
      } else {
        // Ignorer les joueurs non trouvés ou sans nom
        return null;
      }
    }).where((t) => t != null).toList();

    // Trier les tuples par points décroissants
    tuples.sort((a, b) => (b![1] as int).compareTo(a![1] as int));

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Réponse dans une boîte stylisée
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300, // Fond gris
                      borderRadius: BorderRadius.circular(10.0), // Bordures arrondies
                    ),
                    child: Text(
                      'Réponse : $answer',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A1B9A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Affichage du temps restant
                  Text(
                    "${game.countdown}s",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Titre des points
                  const Text(
                    'Points :',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // Liste des joueurs et leurs points
                  Column(
                    children: tuples.map((t) {
                      Player player = t![0] as Player;
                      int playerPoints = t[1] as int;
                      int bonusPoints = t[2] as int;

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200, // Fond léger pour les lignes
                          borderRadius: BorderRadius.circular(12.0), // Bordures arrondies
                        ),
                        child: Row(
                          children: [
                            Text(
                              player.name ?? 'Inconnu',
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6A1B9A),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '$playerPoints (+$bonusPoints)',
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6A1B9A),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
