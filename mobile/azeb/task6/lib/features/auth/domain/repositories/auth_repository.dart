// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<void> login({required String email, required String password});
  Future<void> logout();
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  // Add this method to support the use case
  Future<bool> isLoggedIn();
}
