import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetMyProfileUseCase {
  final UserRepository repository;

  GetMyProfileUseCase(this.repository);

  Future<User> call() async {
    return await repository.getMyProfile();
  }

}
