// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/create_game_screen.dart';
import 'screens/join_game_screen.dart';
import 'stage/game_lounge_stage.dart';
import 'stage/results_stage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color primaryColor = Color(0xFF6A1B9A);
  final Color accentColor = Color(0xFFFFC107);

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
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 18.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/create_game': (context) => CreateGameScreen(),
        '/join_game': (context) => JoinGameScreen(),
        '/game_lounge': (context) => GameLoungeScreen(),
        '/results': (context) => ResultsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
