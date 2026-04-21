import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient supabaseClient;

  AuthRepositoryImpl({required this.supabaseClient});

  @override
  Future<Either<Failure, String>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Supabase'e kayıt işlemi
      // Not: name parametresini 'raw_user_meta_data' içine yolluyoruz ki 
      // PostgreSQL trigger'ımız bu ismi JSON'dan çekip public.users'a yazabilsin.
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
        },
      );

      final userId = response.user?.id;
      if (userId == null) {
        return const Left(UnknownFailure('Kayıt başarılı ancak Kullanıcı ID si alınamadı.'));
      }

      return Right(userId);
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Bilinmeyen bir hata oluştu: \$e'));
    }
  }

  @override
  Future<Either<Failure, String>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final userId = response.user?.id;
      if (userId == null) {
        return const Left(UnknownFailure('Giriş başarısız.'));
      }

      return Right(userId);
    } on AuthException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Bilinmeyen bir hata oluştu: \$e'));
    }
  }

  @override
  String? getCurrentUserId() {
    return supabaseClient.auth.currentUser?.id;
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await supabaseClient.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure('Çıkış yaparken hata oluştu: \$e'));
    }
  }
}
