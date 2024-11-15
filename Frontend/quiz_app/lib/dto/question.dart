import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quiz_app/dto/answer.dart';

part 'question.freezed.dart';
part 'question.g.dart';


@freezed
class Question with _$Question {

  const factory Question({
    required String question,
    required List<String> options,
    required double multiplicator,
    required int answer,
    required Map<String, Answer> answers
  }) = _Question;

  factory Question.fromJson(Map<String, Object?> json) => _$QuestionFromJson(json);

}