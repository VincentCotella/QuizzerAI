// lib/screens/results_screen.dart
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats'),
        backgroundColor: Color(0xFF6A1B9A),
      ),
      body: Center(
        child: Text(
          'Écran des Résultats',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
