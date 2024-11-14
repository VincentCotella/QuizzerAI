// lib/screens/join_game_screen.dart
import 'package:flutter/material.dart';

class JoinGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rejoindre Partie'),
        backgroundColor: Color(0xFF6A1B9A),
      ),
      body: Center(
        child: Text(
          'Écran de rejoindre une partie',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
