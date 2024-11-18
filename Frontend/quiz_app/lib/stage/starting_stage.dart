import 'package:flutter/material.dart';
import 'package:quiz_app/dto/game.dart'; // Assurez-vous que cette importation est correcte

class StartingStage extends StatefulWidget {
  final Game game;

  const StartingStage({required this.game, super.key});

  @override
  State<StartingStage> createState() => _StartingStageState();
}

class _StartingStageState extends State<StartingStage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialiser l'AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this, // `vsync` est fourni par SingleTickerProviderStateMixin
    )..repeat(reverse: true);

    // Définir une animation Tween pour l'échelle
    // Ajustement pour éviter de réduire l'échelle en dessous de 1.0
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Libérer le contrôleur lorsque ce n'est plus nécessaire
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Remplir tout l'espace disponible
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        // Ajouter un dégradé de fond
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
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9), // Fond semi-transparent
              borderRadius: BorderRadius.circular(20.0), // Bordures arrondies
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // Ombre portée
                  blurRadius: 10.0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Adapter la taille au contenu
              children: [
                // Icône animée
                Icon(
                  Icons.play_circle_fill,
                  size: 80.0,
                  color: const Color(0xFF6A1B9A),
                ),
                const SizedBox(height: 20.0),
                // Texte du compte à rebours avec style amélioré
                Text(
                  "Le jeu commence dans ${widget.game.countdown}s !",
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30.0),
                // Barre de progression circulaire
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFBA68C8)),
                  backgroundColor: Colors.grey,
                  strokeWidth: 6.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
