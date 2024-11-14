// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        backgroundColor: Color(0xFF6A1B9A),
      ),
      body: Center(
        child: Text(
          'Écran du Quiz',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
