// lib/screens/game_lounge_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/dto/game.dart';
import 'dart:convert';
import '../screens/quiz_screen.dart';

class StageLoungeScreen extends StatelessWidget {
  final Game game;

  const StageA(this.game, {super.key});
  
  @override
  Widget build(BuildContext context) {
    game.players.
  }


}













class GameLoungeScreen extends StatefulWidget {
  @override
  _GameLoungeScreenState createState() => _GameLoungeScreenState();
}

class _GameLoungeScreenState extends State<GameLoungeScreen> {
  bool _isLoading = true;
  Game? _game;

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
      final response = await http.get(Uri.parse(_gameUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _game = Game.fromJson(data);
          _isLoading = false;
        });

        // Vérifier si le jeu a démarré
        if (_game!.started) {
          // Naviguer vers l'écran du quiz en passant le code de jeu
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuizScreen(game: _game!)));
        }
      } else if (response.statusCode == 404) {
        // Partie non trouvée
        _handleError('Partie non trouvée.');
      } else {
        // Afficher une erreur
        _handleError(
            'Erreur lors de la récupération des détails de la partie. Code: ${response.statusCode}');
      }
    } catch (e) {
      _handleError('Erreur de connexion. Veuillez vérifier votre connexion.');
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
        // Naviguer vers l'écran du quiz en passant le code de jeu
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  QuizScreen(gameCode: _gameDetails!['code'].toString())),
        );
      } else {
        _handleError(
            'Erreur lors du démarrage du jeu. Code: ${response.statusCode}');
      }
    } catch (e) {
      _handleError(
          'Erreur de connexion. Veuillez vérifier votre connexion.');
    }
  }

  Future<void> _deleteGame() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.delete(
        Uri.parse(_gameUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vous avez quitté la partie.')),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        _handleError(data['message'] ??
            'Erreur lors de la suppression de la partie.');
      } else {
        _handleError(
            'Erreur lors de la suppression de la partie. Code: ${response.statusCode}');
      }
    } catch (e) {
      _handleError('Erreur de connexion. Veuillez réessayer.');
    }
  }

  void _handleError(String message) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
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
