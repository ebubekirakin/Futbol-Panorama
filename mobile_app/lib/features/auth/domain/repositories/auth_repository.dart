import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  /// Kullanıcıyı E-posta ve Şifre ile kaydeder
  Future<Either<Failure, String>> signUpWithEmail({
    required String email, 
    required String password,
    required String name,
  });

  /// Kullanıcı giriş işlemi
  Future<Either<Failure, String>> signInWithEmail({
    required String email, 
    required String password,
  });

  /// Güncel kullanıcının ID'sini döndürür
  String? getCurrentUserId();

  /// Çıkış yapma işlemi
  Future<Either<Failure, void>> signOut();
}
