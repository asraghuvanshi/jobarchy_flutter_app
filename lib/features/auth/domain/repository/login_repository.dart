import 'package:jobarchy_flutter_app/features/auth/domain/entities/login_entity.dart';

abstract class LoginRepository {
  Future<bool> login(LoginEntity entity);
}