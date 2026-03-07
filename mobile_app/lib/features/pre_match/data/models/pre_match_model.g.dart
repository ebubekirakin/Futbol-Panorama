// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PreMatchModel _$PreMatchModelFromJson(Map<String, dynamic> json) =>
    _PreMatchModel(
      matchId: json['matchId'] as String,
      homeTeam: json['homeTeam'] as String,
      awayTeam: json['awayTeam'] as String,
      homeWinProbability: (json['homeWinProbability'] as num).toDouble(),
      drawProbability: (json['drawProbability'] as num).toDouble(),
      awayWinProbability: (json['awayWinProbability'] as num).toDouble(),
      aiTacticalReview: json['aiTacticalReview'] as String,
    );

Map<String, dynamic> _$PreMatchModelToJson(_PreMatchModel instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'homeTeam': instance.homeTeam,
      'awayTeam': instance.awayTeam,
      'homeWinProbability': instance.homeWinProbability,
      'drawProbability': instance.drawProbability,
      'awayWinProbability': instance.awayWinProbability,
      'aiTacticalReview': instance.aiTacticalReview,
    };
