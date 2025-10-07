import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_logger.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    AppLogger.logRequest(options);
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.logResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    AppLogger.logError(err);
    if (err.response?.statusCode == 401) {
      // Token expired
      // Clear token and handle logout globally
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      // You can trigger a global logout event here.
    }
    handler.next(err);
  }
}
