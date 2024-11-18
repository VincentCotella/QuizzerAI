import 'package:flutter/material.dart';

import 'package:quiz_app/service/http_service.dart' as http_service;
import 'package:quiz_app/dto/player.dart';
import 'package:quiz_app/service/navigation_service.dart';

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
    player = http_service.fetchPlayer();
    player.then((value) {
      if (value.inGame) {
        http_service.fetchGame()
          .then((game) => goToGame(context, game, value));
      }
      else if (value.name == null) {
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
                  setState(() {
                    player = http_service.changeName(newName);
                  });
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E24AA), Color(0xFFBA68C8)],
          ),
        ),
        child: FutureBuilder(
          future: player, 
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            var p = snapshot.data! as Player;
            return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [Expanded(child: Container())]),
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
                        onPressed: () => Navigator.pushNamed(context, '/create_game', arguments: p),
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
                        onPressed: () => Navigator.pushNamed(context, '/join_game', arguments: p),
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
                  
                );
          },
        ),
      ),
    ));
  }
}
