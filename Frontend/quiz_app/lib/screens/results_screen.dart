// lib/screens/results_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultsScreen extends StatefulWidget {
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _resultsData;

  final String _resultsUrl = 'https://192.168.1.170:8543/game/results';

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(_resultsUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _resultsData = data;
          _isLoading = false;
        });
      } else {
        // Gérer les erreurs
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Erreur lors de la récupération des résultats. Code: ${response.statusCode}')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats'),
        backgroundColor: Color(0xFF6A1B9A),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _resultsData == null
              ? Center(child: Text('Aucun résultat disponible.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Votre Score : ${_resultsData!['score']}/${_resultsData!['total']}',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 24.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              (_resultsData!['details'] as List).length,
                          itemBuilder: (context, index) {
                            var questionResult =
                                _resultsData!['details'][index];
                            return ListTile(
                              title: Text(
                                  'Question ${index + 1}: ${questionResult['question']}'),
                              subtitle: Text(
                                  'Votre réponse: ${questionResult['yourAnswer']}\nBonne réponse: ${questionResult['correctAnswer']}'),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Naviguer vers l'écran d'accueil
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
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
                            'Retour à l\'accueil',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
