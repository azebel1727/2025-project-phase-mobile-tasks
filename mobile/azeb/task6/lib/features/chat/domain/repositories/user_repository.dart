// domain/repositories/user_repository.dart
import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getMyProfile();
  Future<List<User>> getUsers();
}
