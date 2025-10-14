import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jobarchy_flutter_app/core/network/api_service.dart';
import 'package:jobarchy_flutter_app/core/network/network_exceptions.dart';
import 'package:jobarchy_flutter_app/features/model/login_response.dart';



final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<LoginResponse?>>(
  (ref) => LoginViewModel(),
);

class LoginViewModel extends StateNotifier<AsyncValue<LoginResponse?>> {
  final ApiService _apiService = ApiService();

  LoginViewModel() : super(const AsyncData(null));

  Future<void> login(String url, Map<String, dynamic> params) async {
    state = const AsyncLoading();
    try {
      final data = await _apiService.post(url, params);
      final loginResponse = LoginResponse.fromJson(data);
      state = AsyncData(loginResponse);
    } on NoInternetException {
      state = AsyncError('No Internet Connection', StackTrace.current);
    } on NetworkException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
    } catch (e) {
      state = AsyncError('Unexpected error', StackTrace.current);
    }
  }
}
