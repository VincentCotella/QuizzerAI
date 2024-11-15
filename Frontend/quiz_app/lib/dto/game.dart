import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quiz_app/dto/player.dart';
import 'package:quiz_app/dto/question.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
class Game with _$Game {

  const factory Game({
    required int code,
    required int count,
    required String theme,
    required String difficulty,
    required Player owner,
    required bool generating,
    required bool started,
    required bool finished,
    required List<Player> players,
    required List<Question> questions,
    required String state,
    required double stateSince,
    required int currentQuestionIndex,
    required int countdown,
    required Map<String, double> points
  }) = _Game;

  factory Game.fromJson(Map<String, Object?> json) => _$GameFromJson(json);

}