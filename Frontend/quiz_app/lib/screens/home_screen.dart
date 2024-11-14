// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _playerName;
  String? _uuid;

  @override
  void initState() {
    super.initState();
    _fetchPlayerInfo();
  }

  Future<void> _fetchPlayerInfo() async {
    final url = 'https://192.168.1.170:8543/player';
    try {
      var client = BrowserClient()..withCredentials = true;
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          _uuid = data['uuid'];
          _playerName = data['name'];
        });

        if (_playerName == null || _playerName!.isEmpty) {
          _showNameDialog();
        }
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
      }
    } catch (e) {
      print('Exception attrapée : $e');
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
      var client = BrowserClient()..withCredentials = true;
      final response = await client.post(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        setState(() {
          _playerName = data['name'];
        });
      } else {
        print('Erreur lors de la mise à jour du nom : ${response.statusCode}');
      }
    } catch (e) {
      print('Exception attrapée : $e');
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
          child: SingleChildScrollView( // Pour éviter les débordements sur petits écrans
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
                      .displayLarge!
                      .copyWith(color: Colors.white),
                ),
                SizedBox(height: 50.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/quiz');
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF8E24AA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Commencer le Quiz',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/create_game');
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/join_game');
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
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
