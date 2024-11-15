import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';


@freezed
class Player with _$Player {

  const factory Player({
    required String uuid,
    required String? name,
    required bool inGame,
  }) = _Player;

  factory Player.fromJson(Map<String, Object?> json) => _$PlayerFromJson(json);

}