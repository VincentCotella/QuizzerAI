// lib/screens/create_game_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/dto/game.dart';
import 'dart:convert';

import 'package:quiz_app/dto/player.dart';

enum Difficulty {
  BEGINNER("Débutant"),
  EASY("Facile"),
  INTERMEDIATE("Intermédiaire"),
  HARD("Difficile"),
  ADVANCED("Avancé");

  const Difficulty(this.label);
  final String label;
}

class ThemeOption {
  final String name;
  final IconData icon;

  ThemeOption({required this.name, required this.icon});
}

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  late Future<Player> player;
  final _formKey = GlobalKey<FormState>();
  String? _selectedTheme;
  String _customTheme = '';
  Difficulty? _selectedDifficulty;
  int? _selectedNumberOfQuestions;
  bool _isLoading = false;

  // URL de base pour les requêtes au backend
  final String _createGameBaseUrl = 'https://192.168.1.170:8543/game';

  // Liste des thèmes prédéfinis avec des icônes
  final List<ThemeOption> _themes = [
    ThemeOption(name: 'Science', icon: Icons.science),
    ThemeOption(name: 'Histoire', icon: Icons.history_edu),
    ThemeOption(name: 'Géographie', icon: Icons.public),
    ThemeOption(name: 'Littérature', icon: Icons.book),
    ThemeOption(name: 'Art', icon: Icons.palette),
    ThemeOption(name: 'Autre', icon: Icons.more_horiz),
  ];

  // Liste des options pour le nombre de questions
  final List<int> _numberOfQuestionsOptions = [5, 10, 15, 20, 25];

  @override
  void initState() {
    super.initState();
    _selectedTheme = _themes[0].name; // Sélection par défaut
    _selectedDifficulty = Difficulty.EASY; // Sélection par défaut
    _selectedNumberOfQuestions = _numberOfQuestionsOptions[1]; // Sélection par défaut (10)

    const url = 'https://192.168.1.170:8543/player';

    player = http.get(Uri.parse(url))
        .then((data) => jsonDecode(data.body))
        .then((json) => Player.fromJson(json));
  }

  Future<void> _createGame() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });      

      // Déterminer le thème
      String theme = _selectedTheme == 'Autre' ? _customTheme : _selectedTheme!;

      // Déterminer la difficulté en utilisant l'identifiant de l'énumération (majuscule)
      String difficulty = _selectedDifficulty!.name;

      // Déterminer le nombre de questions
      int numberOfQuestions = _selectedNumberOfQuestions!;

      // Construire l'URL avec les paramètres de requête
      Uri url = Uri.parse(_createGameBaseUrl).replace(queryParameters: {
        'difficulty': difficulty, // Utiliser l'identifiant en majuscule
        'theme': theme,
        'count': numberOfQuestions.toString(),
      });

      try {
        final response = await http.post(url);

        if (response.statusCode == 200) {
          var game = Game.fromJson(jsonDecode(response.body));
          // Naviguer vers le salon de jeu
          Navigator.pushNamed(context, '/game', arguments: game);
        } else if (response.statusCode == 400) {
          // Supposons que le serveur retourne 400 avec un message spécifique
          final data = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(data['message'] ?? 'Erreur lors de la création de la partie.')),
          );
        } else {
          // Afficher une erreur générique
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Erreur lors de la création de la partie. Code: ${response.statusCode}')),
          );
        }
      } catch (e) {
        // Gestion des erreurs de connexion
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

  // Méthode pour construire les options de thème
  Widget _buildThemeOption(ThemeOption themeOption) {
    bool isSelected = _selectedTheme == themeOption.name;
    bool isOther = themeOption.name == 'Autre';
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTheme = themeOption.name;
          });
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isSelected
                ? Color(0xFFBA68C8)
                : (isOther ? Colors.orange.shade100 : Colors.white),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0,
                offset: Offset(2, 2),
              ),
            ],
            border: Border.all(
              color: isSelected
                  ? Color(0xFF8E24AA)
                  : (isOther ? Colors.orange.shade700 : Colors.grey.shade300),
              width: 2.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                themeOption.icon,
                size: 30.0,
                color: isSelected
                    ? Colors.white
                    : (isOther ? Colors.orange.shade700 : Color(0xFF8E24AA)),
              ),
              SizedBox(height: 8.0),
              Text(
                themeOption.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isOther ? Colors.orange.shade700 : Color(0xFF8E24AA)),
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour construire les options de difficulté
  Widget _buildDifficultyOption(Difficulty difficulty) {
    bool isSelected = _selectedDifficulty == difficulty;

    // Déterminer le nombre d'étoiles selon la difficulté
    int starCount;
    switch (difficulty) {
      case Difficulty.BEGINNER:
        starCount = 1;
        break;
      case Difficulty.EASY:
        starCount = 2;
        break;
      case Difficulty.INTERMEDIATE:
        starCount = 3;
        break;
      case Difficulty.HARD:
        starCount = 4;
        break;
      case Difficulty.ADVANCED:
        starCount = 5;
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDifficulty = difficulty;
          });
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFBA68C8) : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0,
                offset: Offset(2, 2),
              ),
            ],
            border: Border.all(
              color: isSelected ? Color(0xFF8E24AA) : Colors.grey.shade300,
              width: 2.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Afficher le nombre d'étoiles au-dessus du niveau
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  starCount,
                  (index) => Icon(
                    Icons.star,
                    size: 16.0,
                    color: isSelected ? Colors.white : Color(0xFF8E24AA),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                difficulty.label, // Affiche le label en français
                style: TextStyle(
                  color: isSelected ? Colors.white : Color(0xFF8E24AA),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour construire les options du nombre de questions
  Widget _buildNumberOfQuestionsOption(int number) {
    bool isSelected = _selectedNumberOfQuestions == number;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedNumberOfQuestions = number;
          });
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFBA68C8) : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected ? Color(0xFF8E24AA) : Colors.grey.shade300,
              width: 2.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$number',
                style: TextStyle(
                  color: isSelected ? Colors.white : Color(0xFF8E24AA),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Questions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Color(0xFF8E24AA),
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour déterminer le nombre d'éléments par écran en fonction de la largeur de l'écran
  int _getItemsPerScreen(double screenWidth) {
    if (screenWidth > 1200) return 6;
    if (screenWidth > 800) return 4;
    if (screenWidth > 600) return 3;
    return 2;
  }

  // Méthode pour calculer la largeur des éléments
  double _calculateItemWidth(
      double screenWidth, int itemsPerScreen, double padding) {
    return (screenWidth - (padding * (itemsPerScreen + 1))) / itemsPerScreen;
  }

  @override
  Widget build(BuildContext context) {
    // Obtenir la largeur de l'écran
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = 12.0;

    // Définir combien d'éléments sont affichés par écran pour chaque liste
    int themesPerScreen = _getItemsPerScreen(screenWidth);
    int difficultiesPerScreen = _getItemsPerScreen(screenWidth);
    int questionsPerScreen = _getItemsPerScreen(screenWidth);

    // Calculer la largeur des éléments
    double themeItemWidth =
        _calculateItemWidth(screenWidth, themesPerScreen, padding);
    double difficultyItemWidth =
        _calculateItemWidth(screenWidth, difficultiesPerScreen, padding);
    double questionsItemWidth =
        _calculateItemWidth(screenWidth, questionsPerScreen, padding);

    return Scaffold(
      appBar: AppBar(
        title: Text('Créer Partie'),
        backgroundColor: Color(0xFF6A1B9A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey, // Clé du formulaire
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sélection du thème
                      Text(
                        'Choisissez un thème:',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(
                        height: 120.0,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          itemCount: _themes.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: padding),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: themeItemWidth,
                              child: _buildThemeOption(_themes[index]),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Champ de thème personnalisé
                      if (_selectedTheme == 'Autre') ...[
                        Text(
                          'Entrez votre thème:',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _customTheme = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Votre thème',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                          ),
                          validator: (value) {
                            if (_selectedTheme == 'Autre' &&
                                (value == null || value.isEmpty)) {
                              return 'Veuillez entrer un thème';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                      ],
                      // Sélection de la difficulté
                      Text(
                        'Sélectionnez la difficulté:',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(
                        height: 120.0,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          itemCount: Difficulty.values.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: padding),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: difficultyItemWidth,
                              child:
                                  _buildDifficultyOption(Difficulty.values[index]),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Sélection du nombre de questions
                      const Text(
                        'Nombre de questions:',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        height: 120.0,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          itemCount: _numberOfQuestionsOptions.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: padding),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: questionsItemWidth,
                              child: _buildNumberOfQuestionsOption(
                                  _numberOfQuestionsOptions[index]),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      // Bouton de création de partie
                      Center(
                        child: ElevatedButton(
                          onPressed: _createGame,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 15.0),
                            backgroundColor: const Color(0xFFFFC107),
                            foregroundColor: const Color(0xFF6A1B9A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Text(
                            'Créer Partie',
                            style: TextStyle(fontSize: 20.0),
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
