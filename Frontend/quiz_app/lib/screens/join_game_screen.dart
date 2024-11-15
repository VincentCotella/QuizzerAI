// lib/screens/join_game_screen.dart

import 'package:flutter/material.dart';

import 'package:quiz_app/service/http_service.dart' as http_service;
import 'package:quiz_app/service/navigation_service.dart';

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  String _gameCode = '';

  void _joinGame() {
    http_service.joinGame(int.parse(_gameCode))
      .then((game) => goToGame(context, game))
      .catchError((error) => showDialog(
          context: context, 
          builder: (context) => const Text('Unable to join the game') 
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejoindre Partie'),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Entrez le code PIN de la partie:',
              style:
                TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
              _gameCode = value;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Code PIN',
              contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un code PIN';
              }
              return null;
            },
          ),
          const SizedBox(height: 24.0),
          Center(
            child: ElevatedButton(
            onPressed: _joinGame,
            style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
                horizontal: 40.0, vertical: 15.0),
                backgroundColor: const Color(0xFFFFC107),
                foregroundColor: const Color(0xFF6A1B9A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                ),
              ),
                child: const Text(
                  'Rejoindre Partie',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
