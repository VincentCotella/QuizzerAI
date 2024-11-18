
import 'dart:convert';

import 'package:quiz_app/dto/difficulty.dart';
import 'package:quiz_app/dto/game.dart';
import 'package:quiz_app/dto/player.dart';
import 'package:http/http.dart' as http;

//const String baseUrl = "quizzerai-114409294332.us-central1.run.app"; /api
const String baseUrl = "deploy-frontflutter-114409294332.us-central1.run.app/api";
// 127.0.0.1:8543

Future<Player> fetchPlayer() {
  return http.get(Uri.parse("https://$baseUrl/player"))
      .then((resp) => jsonDecode(resp.body))
      .then((json) => Player.fromJson(json));
}

Future<Game> fetchGame() {
  return http.get(Uri.parse("https://$baseUrl/game"))
      .then((resp) => jsonDecode(resp.body))
      .then((json) => Game.fromJson(json));
}

Future<Player> changeName(String newName) {
  return http.post(Uri.parse("https://$baseUrl/player/name?value=$newName"))
      .then((resp) => jsonDecode(resp.body))
      .then((json) => Player.fromJson(json));
}

void answer(int choice) {
  http.post(Uri.parse("https://$baseUrl/game/answer?choice=$choice"));
}

void startGame() {
  http.post(Uri.parse("https://$baseUrl/game/start"));
}

void leaveGame() {
  http.delete(Uri.parse("https://$baseUrl/game"));
}

Future<Game> joinGame(int gameCode) {
  return http.post(Uri.parse("https://$baseUrl/game/join?code=$gameCode"))
      .then((resp) => jsonDecode(resp.body))
      .then((json) => Game.fromJson(json));
}

Future<Game> createGame(Difficulty difficulty, String theme, int count) {
  return http.post(Uri.parse("https://$baseUrl/game?difficulty=${difficulty.name}&theme=$theme&count=$count"))
      .then((resp) => jsonDecode(resp.body))
      .then((json) => Game.fromJson(json));
      
}