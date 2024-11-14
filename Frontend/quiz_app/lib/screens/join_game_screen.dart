// lib/screens/join_game_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'game_lounge_screen.dart'; // Importez l'écran du salon de jeu

class JoinGameScreen extends StatefulWidget {
  @override
  _JoinGameScreenState createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  final _formKey = GlobalKey<FormState>();
  String _gameCode = '';
  bool _isLoading = false;

  // URL pour rejoindre une partie existante
  final String _joinGameUrl = 'https://192.168.1.170:8543/game/join';

  Future<void> _joinGame() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Envoyer une requête POST à /game/join pour rejoindre une partie
        final response = await http.post(
          Uri.parse("${_joinGameUrl}?code=${_gameCode}"),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'code': _gameCode}),
        );

        if (response.statusCode == 200) {
          // Naviguer vers le salon de jeu
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => GameLoungeScreen()),
            (Route<dynamic> route) => false,
          );
        } else if (response.statusCode == 400) {
          final data = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(data['message'] ?? 'Erreur lors de la jonction de la partie.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erreur lors de la jonction de la partie. Code: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Exception attrapée : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion. Veuillez réessayer.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rejoindre Partie'),
        backgroundColor: Color(0xFF6A1B9A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey, // Clé du formulaire
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entrez le code PIN de la partie:',
                      style:
                          TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      onChanged: (value) {
                        _gameCode = value;
                      },
                      decoration: InputDecoration(
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
                    SizedBox(height: 24.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: _joinGame,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          backgroundColor: Color(0xFFFFC107),
                          foregroundColor: Color(0xFF6A1B9A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
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
