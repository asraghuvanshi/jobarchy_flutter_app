import 'package:dio/dio.dart';
import '../config/environment.dart';
import 'dio_interceptor.dart';
import 'network_exceptions.dart';
import 'network_checker.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: Environment.baseUrl))
    ..interceptors.add(AppInterceptor());

  Future<Response> get(String endpoint) async {
    if (!await NetworkChecker.hasInternet()) {
      throw const NetworkException.noInternet();
    }

    try {
      final response = await _dio.get(endpoint);
      return response;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    if (!await NetworkChecker.hasInternet()) {
      throw const NetworkException.noInternet();
    }

    try {
      final response = await _dio.post(endpoint, data: data);
      print(endpoint);
      print(endpoint);
      return response;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
