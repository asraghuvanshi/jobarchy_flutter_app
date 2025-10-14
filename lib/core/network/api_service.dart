import 'package:dio/dio.dart';
import 'package:jobarchy_flutter_app/core/network/dio_interceptor.dart';
import 'package:jobarchy_flutter_app/core/network/network_exceptions.dart';
import 'network_checker.dart';


class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.interceptors.add(AppInterceptor());
  }

  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> params) async {
    if (!await NetworkChecker.hasInternet()) {
      throw const NoInternetException();
    }

    try {
      final response = await _dio.post(url, data: params);
      return response.data;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
