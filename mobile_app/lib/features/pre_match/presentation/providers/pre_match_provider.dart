import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/pre_match_analysis.dart';
import '../../domain/repositories/pre_match_repository.dart';
import '../data/repositories/pre_match_repository_impl.dart';

final preMatchRepositoryProvider = Provider<PreMatchRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PreMatchRepositoryImpl(client: dio);
});

final preMatchAnalysisProvider = FutureProvider.family<PreMatchAnalysis, String>((ref, matchId) async {
  final repository = ref.watch(preMatchRepositoryProvider);
  final result = await repository.getAnalysisForMatch(matchId);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (analysis) => analysis,
  );
});
