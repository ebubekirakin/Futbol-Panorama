// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pre_match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PreMatchModel {

 String get matchId; String get homeTeam; String get awayTeam; double get homeWinProbability; double get drawProbability; double get awayWinProbability; String get aiTacticalReview;
/// Create a copy of PreMatchModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreMatchModelCopyWith<PreMatchModel> get copyWith => _$PreMatchModelCopyWithImpl<PreMatchModel>(this as PreMatchModel, _$identity);

  /// Serializes this PreMatchModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreMatchModel&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.homeTeam, homeTeam) || other.homeTeam == homeTeam)&&(identical(other.awayTeam, awayTeam) || other.awayTeam == awayTeam)&&(identical(other.homeWinProbability, homeWinProbability) || other.homeWinProbability == homeWinProbability)&&(identical(other.drawProbability, drawProbability) || other.drawProbability == drawProbability)&&(identical(other.awayWinProbability, awayWinProbability) || other.awayWinProbability == awayWinProbability)&&(identical(other.aiTacticalReview, aiTacticalReview) || other.aiTacticalReview == aiTacticalReview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchId,homeTeam,awayTeam,homeWinProbability,drawProbability,awayWinProbability,aiTacticalReview);

@override
String toString() {
  return 'PreMatchModel(matchId: $matchId, homeTeam: $homeTeam, awayTeam: $awayTeam, homeWinProbability: $homeWinProbability, drawProbability: $drawProbability, awayWinProbability: $awayWinProbability, aiTacticalReview: $aiTacticalReview)';
}


}

/// @nodoc
abstract mixin class $PreMatchModelCopyWith<$Res>  {
  factory $PreMatchModelCopyWith(PreMatchModel value, $Res Function(PreMatchModel) _then) = _$PreMatchModelCopyWithImpl;
@useResult
$Res call({
 String matchId, String homeTeam, String awayTeam, double homeWinProbability, double drawProbability, double awayWinProbability, String aiTacticalReview
});




}
/// @nodoc
class _$PreMatchModelCopyWithImpl<$Res>
    implements $PreMatchModelCopyWith<$Res> {
  _$PreMatchModelCopyWithImpl(this._self, this._then);

  final PreMatchModel _self;
  final $Res Function(PreMatchModel) _then;

/// Create a copy of PreMatchModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matchId = null,Object? homeTeam = null,Object? awayTeam = null,Object? homeWinProbability = null,Object? drawProbability = null,Object? awayWinProbability = null,Object? aiTacticalReview = null,}) {
  return _then(_self.copyWith(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,homeTeam: null == homeTeam ? _self.homeTeam : homeTeam // ignore: cast_nullable_to_non_nullable
as String,awayTeam: null == awayTeam ? _self.awayTeam : awayTeam // ignore: cast_nullable_to_non_nullable
as String,homeWinProbability: null == homeWinProbability ? _self.homeWinProbability : homeWinProbability // ignore: cast_nullable_to_non_nullable
as double,drawProbability: null == drawProbability ? _self.drawProbability : drawProbability // ignore: cast_nullable_to_non_nullable
as double,awayWinProbability: null == awayWinProbability ? _self.awayWinProbability : awayWinProbability // ignore: cast_nullable_to_non_nullable
as double,aiTacticalReview: null == aiTacticalReview ? _self.aiTacticalReview : aiTacticalReview // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PreMatchModel].
extension PreMatchModelPatterns on PreMatchModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreMatchModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreMatchModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreMatchModel value)  $default,){
final _that = this;
switch (_that) {
case _PreMatchModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreMatchModel value)?  $default,){
final _that = this;
switch (_that) {
case _PreMatchModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String matchId,  String homeTeam,  String awayTeam,  double homeWinProbability,  double drawProbability,  double awayWinProbability,  String aiTacticalReview)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreMatchModel() when $default != null:
return $default(_that.matchId,_that.homeTeam,_that.awayTeam,_that.homeWinProbability,_that.drawProbability,_that.awayWinProbability,_that.aiTacticalReview);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String matchId,  String homeTeam,  String awayTeam,  double homeWinProbability,  double drawProbability,  double awayWinProbability,  String aiTacticalReview)  $default,) {final _that = this;
switch (_that) {
case _PreMatchModel():
return $default(_that.matchId,_that.homeTeam,_that.awayTeam,_that.homeWinProbability,_that.drawProbability,_that.awayWinProbability,_that.aiTacticalReview);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String matchId,  String homeTeam,  String awayTeam,  double homeWinProbability,  double drawProbability,  double awayWinProbability,  String aiTacticalReview)?  $default,) {final _that = this;
switch (_that) {
case _PreMatchModel() when $default != null:
return $default(_that.matchId,_that.homeTeam,_that.awayTeam,_that.homeWinProbability,_that.drawProbability,_that.awayWinProbability,_that.aiTacticalReview);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PreMatchModel implements PreMatchModel {
  const _PreMatchModel({required this.matchId, required this.homeTeam, required this.awayTeam, required this.homeWinProbability, required this.drawProbability, required this.awayWinProbability, required this.aiTacticalReview});
  factory _PreMatchModel.fromJson(Map<String, dynamic> json) => _$PreMatchModelFromJson(json);

@override final  String matchId;
@override final  String homeTeam;
@override final  String awayTeam;
@override final  double homeWinProbability;
@override final  double drawProbability;
@override final  double awayWinProbability;
@override final  String aiTacticalReview;

/// Create a copy of PreMatchModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreMatchModelCopyWith<_PreMatchModel> get copyWith => __$PreMatchModelCopyWithImpl<_PreMatchModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PreMatchModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreMatchModel&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.homeTeam, homeTeam) || other.homeTeam == homeTeam)&&(identical(other.awayTeam, awayTeam) || other.awayTeam == awayTeam)&&(identical(other.homeWinProbability, homeWinProbability) || other.homeWinProbability == homeWinProbability)&&(identical(other.drawProbability, drawProbability) || other.drawProbability == drawProbability)&&(identical(other.awayWinProbability, awayWinProbability) || other.awayWinProbability == awayWinProbability)&&(identical(other.aiTacticalReview, aiTacticalReview) || other.aiTacticalReview == aiTacticalReview));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchId,homeTeam,awayTeam,homeWinProbability,drawProbability,awayWinProbability,aiTacticalReview);

@override
String toString() {
  return 'PreMatchModel(matchId: $matchId, homeTeam: $homeTeam, awayTeam: $awayTeam, homeWinProbability: $homeWinProbability, drawProbability: $drawProbability, awayWinProbability: $awayWinProbability, aiTacticalReview: $aiTacticalReview)';
}


}

/// @nodoc
abstract mixin class _$PreMatchModelCopyWith<$Res> implements $PreMatchModelCopyWith<$Res> {
  factory _$PreMatchModelCopyWith(_PreMatchModel value, $Res Function(_PreMatchModel) _then) = __$PreMatchModelCopyWithImpl;
@override @useResult
$Res call({
 String matchId, String homeTeam, String awayTeam, double homeWinProbability, double drawProbability, double awayWinProbability, String aiTacticalReview
});




}
/// @nodoc
class __$PreMatchModelCopyWithImpl<$Res>
    implements _$PreMatchModelCopyWith<$Res> {
  __$PreMatchModelCopyWithImpl(this._self, this._then);

  final _PreMatchModel _self;
  final $Res Function(_PreMatchModel) _then;

/// Create a copy of PreMatchModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matchId = null,Object? homeTeam = null,Object? awayTeam = null,Object? homeWinProbability = null,Object? drawProbability = null,Object? awayWinProbability = null,Object? aiTacticalReview = null,}) {
  return _then(_PreMatchModel(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,homeTeam: null == homeTeam ? _self.homeTeam : homeTeam // ignore: cast_nullable_to_non_nullable
as String,awayTeam: null == awayTeam ? _self.awayTeam : awayTeam // ignore: cast_nullable_to_non_nullable
as String,homeWinProbability: null == homeWinProbability ? _self.homeWinProbability : homeWinProbability // ignore: cast_nullable_to_non_nullable
as double,drawProbability: null == drawProbability ? _self.drawProbability : drawProbability // ignore: cast_nullable_to_non_nullable
as double,awayWinProbability: null == awayWinProbability ? _self.awayWinProbability : awayWinProbability // ignore: cast_nullable_to_non_nullable
as double,aiTacticalReview: null == aiTacticalReview ? _self.aiTacticalReview : aiTacticalReview // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
