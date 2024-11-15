// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
      question: json['question'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      multiplicator: (json['multiplicator'] as num).toDouble(),
      answer: (json['answer'] as num).toInt(),
      answers: (json['answers'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Answer.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
      'question': instance.question,
      'options': instance.options,
      'multiplicator': instance.multiplicator,
      'answer': instance.answer,
      'answers': instance.answers,
    };
