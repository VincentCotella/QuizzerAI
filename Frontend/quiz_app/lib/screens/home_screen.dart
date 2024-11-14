// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _playerName;
  String? _uuid;
  bool _isLoading = true;
  bool _inGame = false;
  int? _currentGameCode;

  @override
  void initState() {
    super.initState();
    _fetchPlayerInfo();
  }

  Future<void> _fetchPlayerInfo() async {
    final url = 'https://192.168.1.170:8543/player';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          _uuid = data['uuid'];
          _playerName = data['name'];
          _inGame = data['inGame'] ?? false;
          _currentGameCode = data['currentGameCode'];
          _isLoading = false;
        });

        if (_playerName == null || _playerName!.isEmpty) {
          _showNameDialog();
        }
      } else {
        // Gérer les autres codes de statut si nécessaire
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Erreur lors de la récupération des informations du joueur. Code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Exception attrapée : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion. Veuillez réessayer.')),
      );
    }
  }

  void _showNameDialog() {
    String newName = '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Entrez votre nom"),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
            decoration: InputDecoration(hintText: "Nom du joueur"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newName.isNotEmpty) {
                  Navigator.of(context).pop();
                  _updatePlayerName(newName);
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatePlayerName(String name) async {
    final url = 'https://192.168.1.170:8543/player/name?value=$name';
    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          _playerName = data['name'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Erreur lors de la mise à jour du nom. Code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Exception attrapée : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion. Veuillez réessayer.')),
      );
    }
  }

  Future<void> _deleteGame() async {
    final url = 'https://192.168.1.170:8543/game';
    try {
      final response = await http.delete(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Partie supprimée avec succès.')),
        );

        setState(() {
          _inGame = false;
          _currentGameCode = null;
        });
      } else {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  data['message'] ??
                      'Erreur lors de la suppression de la partie. Code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Exception attrapée : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion. Veuillez réessayer.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Suppression de l'AppBar pour un écran plein
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E24AA), Color(0xFFBA68C8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : SingleChildScrollView(
                  // Pour éviter les débordements sur petits écrans
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.quiz,
                        size: 100.0,
                        color: Colors.white,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        _playerName != null && _playerName!.isNotEmpty
                            ? 'Bienvenue, $_playerName'
                            : 'Bienvenue dans Quiz App',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 50.0),
                      ElevatedButton(
                        onPressed: _inGame
                            ? () {
                                // Afficher un message indiquant que le joueur est déjà dans une partie
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Vous êtes déjà dans une partie. Veuillez la quitter avant de créer une nouvelle partie.')),
                                );
                              }
                            : () {
                                Navigator.pushNamed(context, '/create_game');
                              },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF8E24AA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          'Créer Partie',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _inGame
                            ? () {
                                // Afficher un message indiquant que le joueur est déjà dans une partie
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Vous êtes déjà dans une partie. Veuillez la quitter avant de rejoindre une nouvelle partie.')),
                                );
                              }
                            : () {
                                Navigator.pushNamed(context, '/join_game');
                              },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF8E24AA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          'Rejoindre Partie',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Bouton pour supprimer la partie en cours, visible uniquement si _inGame est true
                      if (_inGame)
                        ElevatedButton(
                          onPressed: _deleteGame,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 15.0),
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: Text(
                            'Quitter Partie',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      SizedBox(height: 20.0),
                      TextButton(
                        onPressed: _showNameDialog,
                        child: Text(
                          'Changer le nom',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
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
