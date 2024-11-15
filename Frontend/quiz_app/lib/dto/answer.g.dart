// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnswerImpl _$$AnswerImplFromJson(Map<String, dynamic> json) => _$AnswerImpl(
      choice: (json['choice'] as num).toInt(),
      point: (json['point'] as num).toInt(),
      duration: json['duration'] as String,
    );

Map<String, dynamic> _$$AnswerImplToJson(_$AnswerImpl instance) =>
    <String, dynamic>{
      'choice': instance.choice,
      'point': instance.point,
      'duration': instance.duration,
    };
