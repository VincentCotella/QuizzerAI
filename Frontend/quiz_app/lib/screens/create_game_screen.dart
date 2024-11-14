// lib/screens/create_game_screen.dart
import 'package:flutter/material.dart';

class CreateGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer Partie'),
        backgroundColor: Color(0xFF6A1B9A),
      ),
      body: Center(
        child: Text(
          'Écran de création de partie',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
