import 'package:flutter/material.dart';
import 'package:quiz_app/dto/game.dart';

class GeneratingStage extends StatefulWidget {
  final Game game; // Définir `game` comme une propriété finale de GeneratingStage

  const GeneratingStage({required this.game, super.key}); // Paramètre nommé requis

  @override
  State<GeneratingStage> createState() => _GeneratingStageState();
}

class _GeneratingStageState extends State<GeneratingStage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialiser l'AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this, // Utiliser `vsync` pour éviter les animations hors écran
    )..repeat(reverse: true);

    // Définir une animation Tween pour l'échelle
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
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
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nouvelle Icône Animée : Pulsation
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Icon(
                    Icons.hourglass_empty, // Icône différente
                    size: 80.0,
                    color: const Color(0xFF6A1B9A),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Code du jeu
                Text(
                  'Code : ${widget.game.code}',
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
                const SizedBox(height: 30.0),
                // Texte animé
                FadeTransition(
                  opacity: _controller,
                  child: const Text(
                    "Génération des questions en cours...",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E24AA),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30.0),
                // Barre de progression
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(const Color(0xFFBA68C8)),
                  backgroundColor: Colors.grey.shade300,
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
