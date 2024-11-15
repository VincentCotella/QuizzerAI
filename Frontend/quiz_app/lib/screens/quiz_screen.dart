// lib/screens/quiz_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'results_screen.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _questionData;
  int _selectedOptionIndex = -1;
  bool _isSubmitting = false;

  final String _nextQuestionUrl = 'https://192.168.1.170:8543/game/next';
  final String _submitAnswerUrl = 'https://192.168.1.170:8543/game/answer';

  @override
  void initState() {
    super.initState();
    _fetchNextQuestion();
  }

  Future<void> _fetchNextQuestion() async {
    setState(() {
      _isLoading = true;
      _selectedOptionIndex = -1;
    });

    try {
      final response = await http.get(
        Uri.parse(_nextQuestionUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null || data.isEmpty) {
          // Pas de question, le quiz est terminé
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ResultsScreen()),
          );
        } else {
          setState(() {
            _questionData = data;
            _isLoading = false;
          });
        }
      } else {
        // Gérer les erreurs
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Erreur lors de la récupération de la question. Code: ${response.statusCode}')),
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

  Future<void> _submitAnswer() async {
    if (_selectedOptionIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner une réponse.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.post(
        Uri.parse(_submitAnswerUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'answer': _selectedOptionIndex}),
      );

      if (response.statusCode == 200) {
        // Réponse envoyée avec succès, passer à la question suivante
        _fetchNextQuestion();
      } else {
        // Gérer les erreurs
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Erreur lors de l\'envoi de la réponse. Code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
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
        title: Text('Quiz'),
        backgroundColor: Color(0xFF6A1B9A),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _questionData == null
              ? Center(child: Text('Aucune question disponible.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _questionData!['question'] ?? 'Question indisponible',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 24.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              (_questionData!['options'] as List).length,
                          itemBuilder: (context, index) {
                            return RadioListTile<int>(
                              title: Text(_questionData!['options'][index]),
                              value: index,
                              groupValue: _selectedOptionIndex,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOptionIndex = value!;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitAnswer,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 15.0),
                            backgroundColor: Color(0xFF6A1B9A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: _isSubmitting
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                )
                              : Text(
                                  'Valider',
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
