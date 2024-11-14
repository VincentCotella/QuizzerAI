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

  // Remplacez par l'URL de votre backend
  final String _joinGameBaseUrl = 'https://192.168.1.170:8543/game/join';

  Future<void> _joinGame() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Construire l'URL avec les paramètres de requête
      Uri url = Uri.parse(_joinGameBaseUrl).replace(queryParameters: {
        'code': _gameCode,
      });

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          // Supposons que le backend renvoie un code PIN valide
          final data = json.decode(response.body);
          String gameCode = data['code'].toString();

          // Naviguer vers le salon de jeu avec le gameCode
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => GameLoungeScreen(gameCode: gameCode)),
            (Route<dynamic> route) => route.isFirst,
          );
        } else {
          // Afficher une erreur
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erreur lors de la jonction de la partie. Code: ${response.statusCode}')),
          );
        }
      } catch (e) {
        // Gestion des erreurs de connexion
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
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
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
