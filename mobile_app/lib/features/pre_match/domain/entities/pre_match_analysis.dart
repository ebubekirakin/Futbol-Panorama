import 'package:freezed_annotation/freezed_annotation.dart';

part 'pre_match_analysis.freezed.dart';

@freezed
class PreMatchAnalysis with _$PreMatchAnalysis {
  const factory PreMatchAnalysis({
    required String matchId,
    required String homeTeam,
    required String awayTeam,
    required double homeWinProbability,
    required double drawProbability,
    required double awayWinProbability,
    required String aiTacticalReview,
  }) = _PreMatchAnalysis;
}
