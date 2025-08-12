// data/repositories/user_repository_impl.dart
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl({required this.remoteDatasource});

  @override
  Future<User> getMyProfile() async {
    return remoteDatasource.getMyProfile();
  }

  @override
  Future<List<User>> getUsers() async {
    return remoteDatasource.getUsers();
  }
}
