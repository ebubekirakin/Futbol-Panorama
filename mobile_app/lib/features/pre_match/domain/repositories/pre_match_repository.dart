import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/pre_match_analysis.dart';

abstract class PreMatchRepository {
  Future<Either<Failure, PreMatchAnalysis>> getAnalysisForMatch(String matchId);
}
