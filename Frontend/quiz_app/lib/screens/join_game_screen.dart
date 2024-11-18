// lib/screens/join_game_screen.dart

import 'package:flutter/material.dart';
import 'package:quiz_app/dto/player.dart';

import 'package:quiz_app/service/http_service.dart' as http_service;
import 'package:quiz_app/service/navigation_service.dart';

class JoinGameScreen extends StatefulWidget {
  final Player player;

  const JoinGameScreen(this.player, {super.key});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  String _gameCode = '';

  void _joinGame() {
    http_service.joinGame(int.parse(_gameCode))
        .then((game) => goToGame(context, game, widget.player))
        .catchError((error) => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Erreur'),
                content: const Text('Impossible de rejoindre la partie'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A1B9A),
              Color(0xFF8E24AA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text(
              'Rejoindre Partie',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false, // Aligné à gauche
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Entrez le code PIN de la partie:',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    onChanged: (value) {
                      _gameCode = value;
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Code PIN',
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 16.0),
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20.0,
                      letterSpacing: 4.0,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un code PIN';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: _joinGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 18.0),
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: const Color(0xFF6A1B9A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 6.0,
                    shadowColor: Colors.black45,
                  ),
                  child: const Text(
                    'Rejoindre Partie',
                    style: TextStyle(
                      fontSize: 20.0,
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
