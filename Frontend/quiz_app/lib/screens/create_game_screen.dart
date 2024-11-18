import 'package:flutter/material.dart';
import 'package:quiz_app/dto/difficulty.dart';
import 'package:quiz_app/dto/player.dart';

import 'package:quiz_app/service/http_service.dart' as http_service;
import 'package:quiz_app/service/navigation_service.dart';

class ThemeOption {
  final String name;
  final IconData icon;

  ThemeOption({required this.name, required this.icon});
}

class CreateGameScreen extends StatefulWidget {
  final Player player;

  const CreateGameScreen(this.player, {super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedTheme;
  String _customTheme = '';
  Difficulty? _selectedDifficulty;
  int? _selectedNumberOfQuestions;

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

  // ScrollControllers pour les sections horizontales
  late ScrollController _themeScrollController;
  late ScrollController _difficultyScrollController;
  late ScrollController _questionsScrollController;

  @override
  void initState() {
    super.initState();
    _selectedTheme = _themes[0].name; // Sélection par défaut
    _selectedDifficulty = Difficulty.EASY; // Sélection par défaut
    _selectedNumberOfQuestions = _numberOfQuestionsOptions[1]; // Sélection par défaut (10)

    // Initialisation des ScrollControllers
    _themeScrollController = ScrollController();
    _difficultyScrollController = ScrollController();
    _questionsScrollController = ScrollController();
  }

  @override
  void dispose() {
    // Libération des ScrollControllers
    _themeScrollController.dispose();
    _difficultyScrollController.dispose();
    _questionsScrollController.dispose();
    super.dispose();
  }

  Future<void> _createGame() async {
    if (_formKey.currentState?.validate() ?? false) {
      String theme = _selectedTheme == 'Autre' ? _customTheme : _selectedTheme!;
      Difficulty difficulty = difficultyFromString(_selectedDifficulty!.name);
      int numberOfQuestions = _selectedNumberOfQuestions!;

      try {
        final game = await http_service.createGame(difficulty, theme, numberOfQuestions);
        goToGame(context, game, widget.player);
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Erreur"),
            content: Text("Impossible de créer une partie : ${error.toString()}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  // Méthode pour construire les options de thème
  Widget _buildThemeOption(ThemeOption themeOption, double itemWidth) {
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
          width: itemWidth,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFBA68C8)
                : (isOther ? Colors.orange.shade100 : Colors.white),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0,
                offset: Offset(2, 2),
              ),
            ],
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF8E24AA)
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
                    : (isOther ? Colors.orange.shade700 : const Color(0xFF8E24AA)),
              ),
              const SizedBox(height: 8.0),
              Text(
                themeOption.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isOther ? Colors.orange.shade700 : const Color(0xFF8E24AA)),
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
  Widget _buildDifficultyOption(Difficulty difficulty, double itemWidth) {
    bool isSelected = _selectedDifficulty == difficulty;
    int starCount = difficulty.index + 1;

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
          width: itemWidth,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFBA68C8) : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0,
                offset: Offset(2, 2),
              ),
            ],
            border: Border.all(
              color: isSelected ? const Color(0xFF8E24AA) : Colors.grey.shade300,
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
                    color: isSelected ? Colors.white : const Color(0xFF8E24AA),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                difficulty.label, // Affiche le label en français
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF8E24AA),
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
  Widget _buildNumberOfQuestionsOption(int number, double itemWidth) {
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
          width: itemWidth,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFBA68C8) : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected ? const Color(0xFF8E24AA) : Colors.grey.shade300,
              width: 2.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$number',
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF8E24AA),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Questions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF8E24AA),
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
    // Calculer la largeur totale disponible en soustrayant les paddings
    double totalPadding = padding * (itemsPerScreen + 1);
    double availableWidth = screenWidth - totalPadding;
    return availableWidth / itemsPerScreen;
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
        title: const Text('Créer Partie'),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Clé du formulaire
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sélection du thème
                const Text(
                  'Choisissez un thème:',
                  style: TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  height: 120.0,
                  child: Scrollbar(
                    controller: _themeScrollController,
                    thumbVisibility: true, // Affiche toujours la barre de défilement
                    child: ListView.separated(
                      controller: _themeScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      itemCount: _themes.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: padding),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: themeItemWidth,
                          child: _buildThemeOption(_themes[index], themeItemWidth),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Champ de thème personnalisé
                if (_selectedTheme == 'Autre') ...[
                  const Text(
                    'Entrez votre thème:',
                    style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _customTheme = value;
                      });
                    },
                    decoration: const InputDecoration(
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
                  const SizedBox(height: 16.0),
                ],
                // Sélection de la difficulté
                const Text(
                  'Sélectionnez la difficulté:',
                  style: TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  height: 120.0,
                  child: Scrollbar(
                    controller: _difficultyScrollController,
                    thumbVisibility: true,
                    child: ListView.separated(
                      controller: _difficultyScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      itemCount: Difficulty.values.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: padding),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: difficultyItemWidth,
                          child: _buildDifficultyOption(Difficulty.values[index], difficultyItemWidth),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Sélection du nombre de questions
                const Text(
                  'Nombre de questions:',
                  style: TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  height: 120.0,
                  child: Scrollbar(
                    controller: _questionsScrollController,
                    thumbVisibility: true,
                    child: ListView.separated(
                      controller: _questionsScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      itemCount: _numberOfQuestionsOptions.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: padding),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: questionsItemWidth,
                          child: _buildNumberOfQuestionsOption(
                              _numberOfQuestionsOptions[index], questionsItemWidth),
                        );
                      },
                    ),
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
