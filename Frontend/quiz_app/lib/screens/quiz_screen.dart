// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:websocket_universal/websocket_universal.dart';
import 'dart:convert';

import 'results_screen.dart';

class QuizScreen extends StatefulWidget {
  final String gameCode;

  QuizScreen({required this.gameCode});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late IWebSocketHandler<String, String> _channel;
  Map<String, dynamic>? _questionData;
  int _selectedOptionIndex = -1;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  Future<void> _connectToWebSocket() async {
    final wsUrl = 'wss://192.168.1.170:8543/game/live';
    
    _channel = IWebSocketHandler<String, String>.createClient(
      wsUrl,
      SocketSimpleTextProcessor(),
    );

    // Connecter avec le header X-GameCode
    await _channel.connect(headers: {'X-GameCode': widget.gameCode});

    // Écouter les messages du serveur
    _channel.incomingMessagesStream.listen((message) {
      final data = json.decode(message);
      if (data['finished'] == true) {
        // Naviguer vers l'écran des résultats si le quiz est terminé
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResultsScreen()),
        );
      } else {
        setState(() {
          _questionData = data;
          _selectedOptionIndex = -1;
        });
      }
    }, onError: (error) {
      print('Erreur WebSocket : $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion au serveur.')),
      );
    });
  }

  void _submitAnswer() {
    if (_selectedOptionIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner une réponse.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Envoyer la réponse sélectionnée au serveur WebSocket
    _channel.sendMessage(json.encode({'answer': _selectedOptionIndex}));

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  void dispose() {
    _channel.disconnect(); // Ferme la connexion WebSocket lorsque l'écran est fermé
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        backgroundColor: Color(0xFF6A1B9A),
      ),
      body: _questionData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _questionData!['question'] ?? 'Question indisponible',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: (_questionData!['options'] as List).length,
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
                        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                        backgroundColor: Color(0xFF6A1B9A),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Valider', style: TextStyle(fontSize: 20.0)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
