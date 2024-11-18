
import 'dart:convert';

import 'package:quiz_app/dto/difficulty.dart';
import 'package:quiz_app/dto/game.dart';
import 'package:quiz_app/dto/player.dart';
import 'dart:html' as html;

const String baseUrl = "quizzerai-114409294332.us-central1.run.app";

Future<dynamic> execute(String method, String uri, {bool decode = true}) {
  var request = html.HttpRequest();
  request.withCredentials = true; 
  request.open(method, 'https://$baseUrl$uri');
  request.send();

  if (!decode) {
    return request.onLoadEnd.first;
  }

  return request.onLoadEnd.first.then((_) => jsonDecode(request.responseText!));
}

Future<Player> fetchPlayer() => execute('GET', '/player')
    .then((j) => Player.fromJson(j));

Future<Game> fetchGame() => execute('GET', '/game')
    .then((j) => Game.fromJson(j));

Future<Player> changeName(String newName) => execute('POST', '/player/name?value=$newName')
    .then((j) => Player.fromJson(j));

void answer(int choice) => execute('POST', '/game/answer?choice=$choice', decode: false);

void startGame() => execute('POST', '/game/start', decode: false);

void leaveGame() => execute('DELETE', '/game', decode: false);

Future<Game> joinGame(int gameCode) => execute('POST', '/game/join?code=$gameCode')
    .then((j) => Game.fromJson(j));

Future<Game> createGame(Difficulty difficulty, String theme, int count) => execute('POST', '/game?difficulty=${difficulty.name}&theme=$theme&count=$count')
    .then((j) => Game.fromJson(j));
