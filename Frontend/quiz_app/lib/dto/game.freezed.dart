// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Game _$GameFromJson(Map<String, dynamic> json) {
  return _Game.fromJson(json);
}

/// @nodoc
mixin _$Game {
  int get code => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  String get theme => throw _privateConstructorUsedError;
  String get difficulty => throw _privateConstructorUsedError;
  Player get owner => throw _privateConstructorUsedError;
  bool get generating => throw _privateConstructorUsedError;
  bool get started => throw _privateConstructorUsedError;
  bool get finished => throw _privateConstructorUsedError;
  List<Player> get players => throw _privateConstructorUsedError;
  List<Question> get questions => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  DateTime get stateSince => throw _privateConstructorUsedError;
  int get currentQuestionIndex => throw _privateConstructorUsedError;
  int get countdown => throw _privateConstructorUsedError;
  Map<String, double> get points => throw _privateConstructorUsedError;

  /// Serializes this Game to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameCopyWith<Game> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameCopyWith<$Res> {
  factory $GameCopyWith(Game value, $Res Function(Game) then) =
      _$GameCopyWithImpl<$Res, Game>;
  @useResult
  $Res call(
      {int code,
      int count,
      String theme,
      String difficulty,
      Player owner,
      bool generating,
      bool started,
      bool finished,
      List<Player> players,
      List<Question> questions,
      String state,
      DateTime stateSince,
      int currentQuestionIndex,
      int countdown,
      Map<String, double> points});

  $PlayerCopyWith<$Res> get owner;
}

/// @nodoc
class _$GameCopyWithImpl<$Res, $Val extends Game>
    implements $GameCopyWith<$Res> {
  _$GameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? count = null,
    Object? theme = null,
    Object? difficulty = null,
    Object? owner = null,
    Object? generating = null,
    Object? started = null,
    Object? finished = null,
    Object? players = null,
    Object? questions = null,
    Object? state = null,
    Object? stateSince = null,
    Object? currentQuestionIndex = null,
    Object? countdown = null,
    Object? points = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as Player,
      generating: null == generating
          ? _value.generating
          : generating // ignore: cast_nullable_to_non_nullable
              as bool,
      started: null == started
          ? _value.started
          : started // ignore: cast_nullable_to_non_nullable
              as bool,
      finished: null == finished
          ? _value.finished
          : finished // ignore: cast_nullable_to_non_nullable
              as bool,
      players: null == players
          ? _value.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      stateSince: null == stateSince
          ? _value.stateSince
          : stateSince // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentQuestionIndex: null == currentQuestionIndex
          ? _value.currentQuestionIndex
          : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      countdown: null == countdown
          ? _value.countdown
          : countdown // ignore: cast_nullable_to_non_nullable
              as int,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ) as $Val);
  }

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get owner {
    return $PlayerCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameImplCopyWith<$Res> implements $GameCopyWith<$Res> {
  factory _$$GameImplCopyWith(
          _$GameImpl value, $Res Function(_$GameImpl) then) =
      __$$GameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int code,
      int count,
      String theme,
      String difficulty,
      Player owner,
      bool generating,
      bool started,
      bool finished,
      List<Player> players,
      List<Question> questions,
      String state,
      DateTime stateSince,
      int currentQuestionIndex,
      int countdown,
      Map<String, double> points});

  @override
  $PlayerCopyWith<$Res> get owner;
}

/// @nodoc
class __$$GameImplCopyWithImpl<$Res>
    extends _$GameCopyWithImpl<$Res, _$GameImpl>
    implements _$$GameImplCopyWith<$Res> {
  __$$GameImplCopyWithImpl(_$GameImpl _value, $Res Function(_$GameImpl) _then)
      : super(_value, _then);

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? count = null,
    Object? theme = null,
    Object? difficulty = null,
    Object? owner = null,
    Object? generating = null,
    Object? started = null,
    Object? finished = null,
    Object? players = null,
    Object? questions = null,
    Object? state = null,
    Object? stateSince = null,
    Object? currentQuestionIndex = null,
    Object? countdown = null,
    Object? points = null,
  }) {
    return _then(_$GameImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as Player,
      generating: null == generating
          ? _value.generating
          : generating // ignore: cast_nullable_to_non_nullable
              as bool,
      started: null == started
          ? _value.started
          : started // ignore: cast_nullable_to_non_nullable
              as bool,
      finished: null == finished
          ? _value.finished
          : finished // ignore: cast_nullable_to_non_nullable
              as bool,
      players: null == players
          ? _value._players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      stateSince: null == stateSince
          ? _value.stateSince
          : stateSince // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentQuestionIndex: null == currentQuestionIndex
          ? _value.currentQuestionIndex
          : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      countdown: null == countdown
          ? _value.countdown
          : countdown // ignore: cast_nullable_to_non_nullable
              as int,
      points: null == points
          ? _value._points
          : points // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameImpl implements _Game {
  const _$GameImpl(
      {required this.code,
      required this.count,
      required this.theme,
      required this.difficulty,
      required this.owner,
      required this.generating,
      required this.started,
      required this.finished,
      required final List<Player> players,
      required final List<Question> questions,
      required this.state,
      required this.stateSince,
      required this.currentQuestionIndex,
      required this.countdown,
      required final Map<String, double> points})
      : _players = players,
        _questions = questions,
        _points = points;

  factory _$GameImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameImplFromJson(json);

  @override
  final int code;
  @override
  final int count;
  @override
  final String theme;
  @override
  final String difficulty;
  @override
  final Player owner;
  @override
  final bool generating;
  @override
  final bool started;
  @override
  final bool finished;
  final List<Player> _players;
  @override
  List<Player> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  final List<Question> _questions;
  @override
  List<Question> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  final String state;
  @override
  final DateTime stateSince;
  @override
  final int currentQuestionIndex;
  @override
  final int countdown;
  final Map<String, double> _points;
  @override
  Map<String, double> get points {
    if (_points is EqualUnmodifiableMapView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_points);
  }

  @override
  String toString() {
    return 'Game(code: $code, count: $count, theme: $theme, difficulty: $difficulty, owner: $owner, generating: $generating, started: $started, finished: $finished, players: $players, questions: $questions, state: $state, stateSince: $stateSince, currentQuestionIndex: $currentQuestionIndex, countdown: $countdown, points: $points)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.generating, generating) ||
                other.generating == generating) &&
            (identical(other.started, started) || other.started == started) &&
            (identical(other.finished, finished) ||
                other.finished == finished) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.stateSince, stateSince) ||
                other.stateSince == stateSince) &&
            (identical(other.currentQuestionIndex, currentQuestionIndex) ||
                other.currentQuestionIndex == currentQuestionIndex) &&
            (identical(other.countdown, countdown) ||
                other.countdown == countdown) &&
            const DeepCollectionEquality().equals(other._points, _points));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      code,
      count,
      theme,
      difficulty,
      owner,
      generating,
      started,
      finished,
      const DeepCollectionEquality().hash(_players),
      const DeepCollectionEquality().hash(_questions),
      state,
      stateSince,
      currentQuestionIndex,
      countdown,
      const DeepCollectionEquality().hash(_points));

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      __$$GameImplCopyWithImpl<_$GameImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameImplToJson(
      this,
    );
  }
}

abstract class _Game implements Game {
  const factory _Game(
      {required final int code,
      required final int count,
      required final String theme,
      required final String difficulty,
      required final Player owner,
      required final bool generating,
      required final bool started,
      required final bool finished,
      required final List<Player> players,
      required final List<Question> questions,
      required final String state,
      required final DateTime stateSince,
      required final int currentQuestionIndex,
      required final int countdown,
      required final Map<String, double> points}) = _$GameImpl;

  factory _Game.fromJson(Map<String, dynamic> json) = _$GameImpl.fromJson;

  @override
  int get code;
  @override
  int get count;
  @override
  String get theme;
  @override
  String get difficulty;
  @override
  Player get owner;
  @override
  bool get generating;
  @override
  bool get started;
  @override
  bool get finished;
  @override
  List<Player> get players;
  @override
  List<Question> get questions;
  @override
  String get state;
  @override
  DateTime get stateSince;
  @override
  int get currentQuestionIndex;
  @override
  int get countdown;
  @override
  Map<String, double> get points;

  /// Create a copy of Game
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
