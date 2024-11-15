// lib/screens/game_lounge_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'quiz_screen.dart'; // Assurez-vous que cette importation est présente
import 'home_screen.dart'; // Si vous en avez besoin pour la navigation

class GameLoungeScreen extends StatefulWidget {
  @override
  _GameLoungeScreenState createState() => _GameLoungeScreenState();
}

class _GameLoungeScreenState extends State<GameLoungeScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _gameDetails;

  // URL pour les requêtes au backend
  final String _gameUrl = 'https://192.168.1.170:8543/game';

  @override
  void initState() {
    super.initState();
    _fetchGameDetails();
  }

  Future<void> _fetchGameDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Envoyer une requête GET à /game pour obtenir les détails de la partie actuelle
      final response = await http.get(
        Uri.parse(_gameUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _gameDetails = data;
          _isLoading = false;
        });

        // Vérifier si le jeu a démarré
        if (_gameDetails!['started'] == true) {
          // Naviguer vers l'écran du quiz
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => QuizScreen()),
          );
        }
      } else if (response.statusCode == 404) {
        // Partie non trouvée
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Partie non trouvée.')),
        );
        Navigator.pop(context); // Retourner à l'écran précédent
      } else {
        // Afficher une erreur
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Erreur lors de la récupération des détails de la partie. Code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Exception attrapée : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erreur de connexion. Veuillez vérifier votre connexion.')),
      );
    }
  }

  Future<void> _startGame() async {
    setState(() {
      _isLoading = true;
    });

    final String _startGameUrl = 'https://192.168.1.170:8543/game/start';

    try {
      final response = await http.post(
        Uri.parse(_startGameUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Naviguer vers l'écran du quiz
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizScreen()),
        );
      } else {
        // Gérer les erreurs
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Erreur lors du démarrage du jeu. Code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Exception attrapée : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erreur de connexion. Veuillez vérifier votre connexion.')),
      );
    }
  }

  Future<void> _deleteGame() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Envoyer une requête DELETE à /game pour quitter la partie
      final response = await http.delete(
        Uri.parse(_gameUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vous avez quitté la partie.')),
        );
        // Naviguer vers l'écran d'accueil
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  data['message'] ?? 'Erreur lors de la suppression de la partie.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Erreur lors de la suppression de la partie. Code: ${response.statusCode}')),
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

  Widget _buildPlayerList(List<dynamic> players) {
    return players.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: players.length,
            itemBuilder: (context, index) {
              var player = players[index];
              return ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                title: Text(player['name'] ?? 'Inconnu'),
              );
            },
          )
        : Text('Aucun joueur connecté.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salon de Jeu'),
        backgroundColor: Color(0xFF6A1B9A),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _deleteGame,
            tooltip: 'Quitter la partie',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchGameDetails,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _gameDetails == null
                ? Center(child: Text('Aucune donnée disponible.'))
                : SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Code PIN: ${_gameDetails!['code']}',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Thème: ${_gameDetails!['theme']}',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Difficulté: ${_gameDetails!['difficulty']}',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Nombre de Questions: ${_gameDetails!['count']}',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          SizedBox(height: 24.0),
                          Text(
                            'Joueurs Connectés:',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0),
                          _buildPlayerList(_gameDetails!['players']),
                          SizedBox(height: 24.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _startGame,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 15.0),
                                backgroundColor: Color(0xFF6A1B9A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Text(
                                      'Démarrer le Quiz',
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchGameDetails,
        child: Icon(Icons.refresh),
        backgroundColor: Color(0xFF6A1B9A),
      ),
    );
  }
}
