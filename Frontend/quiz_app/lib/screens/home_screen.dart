// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quiz_app/dto/player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Player> player;

  @override
  void initState() {
    super.initState();
    const url = 'https://192.168.1.170:8543/player';

    player = http.get(Uri.parse(url))
        .then((data) => jsonDecode(data.body))
        .then((json) => Player.fromJson(json));

    player.then((value) {
      if (value.name == null) {
        _showEditNameDialog();
      }
    });
  }

  void _showEditNameDialog() {
    String newName = '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Entrez votre nom"),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
            decoration: const InputDecoration(hintText: "Nom du joueur"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newName.isNotEmpty) {
                  Navigator.of(context).pop();
                  _updatePlayerName(newName);
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatePlayerName(String name) async {
    final url = 'https://192.168.1.170:8543/player/name?value=$name';
    
    setState(() {
      player = http.post(Uri.parse(url))
          .then((resp) => jsonDecode(resp.body))
          .then((json) => Player.fromJson(json));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Suppression de l'AppBar pour un écran plein
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E24AA), Color(0xFFBA68C8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder(
          future: player, 
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            var p = snapshot.data! as Player;
            return SingleChildScrollView(
                  // Pour éviter les débordements sur petits écrans
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.quiz,
                        size: 100.0,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        p.name != null && p.name!.isNotEmpty
                            ? 'Bienvenue, ${p.name}'
                            : 'Bienvenue dans Quiz App',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 50.0),
                      ElevatedButton(
                        onPressed: p.inGame
                            ? () {
                                // Afficher un message indiquant que le joueur est déjà dans une partie
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Vous êtes déjà dans une partie. Veuillez la quitter avant de créer une nouvelle partie.')),
                                );
                              }
                            : () {
                                
                                Navigator.pushNamed(context, '/create_game', arguments: p);
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF8E24AA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Créer Partie',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: p.inGame
                            ? () {
                                // Afficher un message indiquant que le joueur est déjà dans une partie
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Vous êtes déjà dans une partie. Veuillez la quitter avant de rejoindre une nouvelle partie.')),
                                );
                              }
                            : () {
                                Navigator.pushNamed(context, '/join_game');
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF8E24AA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Rejoindre Partie',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextButton(
                        onPressed: _showEditNameDialog,
                        child: const Text(
                          'Changer le nom',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                );
          },
        ),
      ),
    );
  }
}
