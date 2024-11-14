// lib/screens/game_lounge_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameLoungeScreen extends StatefulWidget {
  final String gameCode;

  GameLoungeScreen({required this.gameCode});

  @override
  _GameLoungeScreenState createState() => _GameLoungeScreenState();
}

class _GameLoungeScreenState extends State<GameLoungeScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _gameDetails;

  // Remplacez par l'URL de votre backend
  final String _getGameDetailsUrl = 'https://192.168.1.170:8543/game/details';

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
      // Construire l'URL avec les paramètres de requête
      Uri url = Uri.parse(_getGameDetailsUrl).replace(queryParameters: {
        'code': widget.gameCode,
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _gameDetails = data;
        });
      } else {
        // Afficher une erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Erreur lors de la récupération des détails de la partie. Code: ${response.statusCode}')),
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

  Widget _buildPlayerList(List<dynamic> players, {bool isJoined = false}) {
    return players.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: players.length,
            itemBuilder: (context, index) {
              var player = players[index];
              return ListTile(
                leading: Icon(
                  isJoined ? Icons.check_circle : Icons.person,
                  color: isJoined ? Colors.green : Colors.blue,
                ),
                title: Text(player['name'] ?? 'Inconnu'),
              );
            },
          )
        : Text(isJoined
            ? 'Aucun joueur n\'a rejoint la partie.'
            : 'Aucun joueur connecté.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salon de Jeu'),
        backgroundColor: Color(0xFF6A1B9A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _gameDetails == null
                ? Center(child: Text('Aucune donnée disponible.'))
                : SingleChildScrollView(
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
                        ElevatedButton(
                          onPressed: () {
                            // Logique pour démarrer le quiz si vous êtes le maître du jeu
                            // Par exemple, vérifier si vous êtes le créateur de la partie et lancer le quiz
                            // Cette fonctionnalité peut être implémentée selon vos besoins
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 15.0),
                            backgroundColor: Color(0xFF6A1B9A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: Text(
                            'Démarrer le Quiz',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ],
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
