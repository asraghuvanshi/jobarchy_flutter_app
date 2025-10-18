import 'package:dio/dio.dart';
import 'package:jobarchy_flutter_app/core/utils/sharedpreference.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPrefsHelper.getToken();
    final token = prefs;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      // Optionally navigate to login screen
    }
    handler.next(err);
  }
}
