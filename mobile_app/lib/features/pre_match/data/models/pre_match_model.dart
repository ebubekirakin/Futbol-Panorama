import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/pre_match_analysis.dart';

part 'pre_match_model.freezed.dart';
part 'pre_match_model.g.dart';

@freezed
class PreMatchModel with _$PreMatchModel {
  const factory PreMatchModel({
    required String matchId,
    required String homeTeam,
    required String awayTeam,
    required double homeWinProbability,
    required double drawProbability,
    required double awayWinProbability,
    required String aiTacticalReview,
  }) = _PreMatchModel;

  factory PreMatchModel.fromJson(Map<String, dynamic> json) =>
      _$PreMatchModelFromJson(json);
}

extension PreMatchModelMapper on PreMatchModel {
  PreMatchAnalysis toEntity() {
    return PreMatchAnalysis(
      matchId: matchId,
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      homeWinProbability: homeWinProbability,
      drawProbability: drawProbability,
      awayWinProbability: awayWinProbability,
      aiTacticalReview: aiTacticalReview,
    );
  }
}
