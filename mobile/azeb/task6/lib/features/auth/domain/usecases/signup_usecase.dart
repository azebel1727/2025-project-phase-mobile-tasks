import '../repositories/auth_repository.dart';

// signup_usecase.dart

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<void> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.signUp(name: name, email: email, password: password);
  }
}
