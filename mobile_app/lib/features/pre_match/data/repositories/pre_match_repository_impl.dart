import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/pre_match_analysis.dart';
import '../../domain/repositories/pre_match_repository.dart';
import '../models/pre_match_model.dart';

class PreMatchRepositoryImpl implements PreMatchRepository {
  final Dio client;

  PreMatchRepositoryImpl({required this.client});

  @override
  Future<Either<Failure, PreMatchAnalysis>> getAnalysisForMatch(String matchId) async {
    try {
      // Örnek API çağrısı
      // final response = await client.get('/match/$matchId/pre-analysis');
      
      // Şimdilik mock veri dönüyoruz (Backend yazılana kadar)
      await Future.delayed(const Duration(seconds: 1));
      final mockData = {
        'matchId': matchId,
        'homeTeam': 'Galatasaray',
        'awayTeam': 'Fenerbahçe',
        'homeWinProbability': 45.5,
        'drawProbability': 25.0,
        'awayWinProbability': 29.5,
        'aiTacticalReview': 'Zorlu bir derbi. Ev sahibi ekibin ön alan baskısı belirleyici olacak.'
      };

      final model = PreMatchModel.fromJson(mockData);
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.response != null) {
        return Left(ServerFailure('Sunucu Hatası: \${e.response?.statusCode}'));
      } else {
        return const Left(NetworkFailure('Ağ bağlantısı kurulamadı.'));
      }
    } catch (e) {
      return Left(UnknownFailure('Beklenmeyen bir hata oluştu: \$e'));
    }
  }
}
