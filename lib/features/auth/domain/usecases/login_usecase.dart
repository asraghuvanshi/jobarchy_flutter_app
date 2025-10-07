import 'package:jobarchy_flutter_app/features/auth/domain/repository/login_repository.dart';
import '../entities/login_entity.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<bool> execute(LoginEntity entity) async {
    return await repository.login(entity);
  }
}
