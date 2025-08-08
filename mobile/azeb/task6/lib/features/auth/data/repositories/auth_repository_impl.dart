import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return remoteDataSource.signUp(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final token = await remoteDataSource.login(
      email: email,
      password: password,
    );
    await localDataSource.cacheToken(token);
    return token;
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearToken();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getToken();
    // You can add more checks here (e.g. token expiration validation)
    return token != null && token.isNotEmpty;
  }
}
