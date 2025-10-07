import 'dart:convert';
import 'package:jobarchy_flutter_app/core/network/api_client.dart';
import 'package:jobarchy_flutter_app/core/network/network_exceptions.dart';
import 'package:jobarchy_flutter_app/features/auth/domain/entities/login_entity.dart';
import 'package:jobarchy_flutter_app/features/auth/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final ApiClient apiClient;

  LoginRepositoryImpl(this.apiClient);

  @override
  Future<bool> login(LoginEntity entity) async {
    try {
      final response = await apiClient.post(
        "/auth/login",
        data: jsonEncode({
          'email': entity.email,
          'password': entity.password,
        }),
      );
      return response.statusCode == 200;
    } on NetworkException catch (e) {
      rethrow; // handled by ViewModel
    }
  }
}
