import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jobarchy_flutter_app/core/network/api_service.dart';
import 'package:jobarchy_flutter_app/core/network/network_exceptions.dart';
import 'package:jobarchy_flutter_app/core/utils/sharedpreference.dart';
import 'package:jobarchy_flutter_app/features/model/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<LoginModel?>>(
      (ref) => LoginViewModel(),
    );

class LoginViewModel extends StateNotifier<AsyncValue<LoginModel?>> {
  final ApiService _apiService = ApiService();

  LoginViewModel() : super(const AsyncData(null));

  String? validate(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return 'Email and password are required.';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }

  Future<void> login(String url, String email, String password) async {
    final validationError = validate(email, password);
    if (validationError != null) {
      state = AsyncError(validationError, StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    try {
      final data = await _apiService.post(url, {
        'email': email,
        'password': password,
      });
      final loginResponse = LoginModel.fromJson(data);
      if (loginResponse.data.token.isNotEmpty) {
        SharedPrefsHelper.saveToken(loginResponse.data.token);
      }
      state = AsyncData(loginResponse);
    } on NoInternetException {
      state = AsyncError('No Internet Connection', StackTrace.current);
    } on NetworkException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
    } catch (e) {
      state = AsyncError('Unexpected error occurred', StackTrace.current);
    }
  }
}
