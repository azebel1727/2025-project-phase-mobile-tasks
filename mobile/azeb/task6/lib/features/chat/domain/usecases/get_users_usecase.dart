import '../../domain/entities/user.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<User>> call() async {
    return await repository.getUsers();
  }
}
