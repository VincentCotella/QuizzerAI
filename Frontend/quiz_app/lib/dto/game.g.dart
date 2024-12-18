// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameImpl _$$GameImplFromJson(Map<String, dynamic> json) => _$GameImpl(
      code: (json['code'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      theme: json['theme'] as String,
      difficulty: $enumDecode(_$DifficultyEnumMap, json['difficulty']),
      owner: Player.fromJson(json['owner'] as Map<String, dynamic>),
      generating: json['generating'] as bool,
      started: json['started'] as bool,
      finished: json['finished'] as bool,
      players: (json['players'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      state: json['state'] as String,
      currentQuestionIndex: (json['currentQuestionIndex'] as num).toInt(),
      countdown: (json['countdown'] as num).toInt(),
      points: (json['points'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$$GameImplToJson(_$GameImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'count': instance.count,
      'theme': instance.theme,
      'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
      'owner': instance.owner,
      'generating': instance.generating,
      'started': instance.started,
      'finished': instance.finished,
      'players': instance.players,
      'questions': instance.questions,
      'state': instance.state,
      'currentQuestionIndex': instance.currentQuestionIndex,
      'countdown': instance.countdown,
      'points': instance.points,
    };

const _$DifficultyEnumMap = {
  Difficulty.BEGINNER: 'BEGINNER',
  Difficulty.EASY: 'EASY',
  Difficulty.INTERMEDIATE: 'INTERMEDIATE',
  Difficulty.HARD: 'HARD',
  Difficulty.ADVANCED: 'ADVANCED',
};
