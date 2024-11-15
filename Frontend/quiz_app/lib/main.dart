import 'package:flutter/material.dart';
import 'package:quiz_app/dto/game.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'screens/home_screen.dart';
import 'screens/create_game_screen.dart';
import 'screens/join_game_screen.dart';
import 'stage/results_stage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final Color primaryColor = const Color(0xFF6A1B9A);
  final Color accentColor = const Color(0xFFFFC107);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          secondary: accentColor,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 18.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/create_game': (context) => const CreateGameScreen(),
        '/join_game': (context) => const JoinGameScreen(),
        '/game': (context) => QuizScreen(ModalRoute.settingsOf(context)!.arguments as Game),
        '/results': (context) => ResultsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
