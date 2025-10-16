import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jobarchy_flutter_app/core/network/dio_interceptor.dart';
import 'package:jobarchy_flutter_app/core/network/network_exceptions.dart';
import 'network_checker.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.interceptors.add(AppInterceptor());

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint('[DIO] $obj'),
      ));
    }
  }

  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> params) async {
    if (!await NetworkChecker.hasInternet()) {
      throw const NoInternetException();
    }

    try {
      if (kDebugMode) {
        debugPrint('POST Request → $url');
        debugPrint('Body: $params');
      }

      final response = await _dio.post(url, data: params);

      if (kDebugMode) {
        debugPrint('Response [${response.statusCode}] from $url');
        debugPrint('Data: ${response.data}');
      }

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('Dio Error → ${e.type}');
        debugPrint('Message: ${e.message}');
        debugPrint('URL: $url');
      }
      throw NetworkException.fromDioError(e);
    } catch (e) {
      if (kDebugMode) debugPrint('Unexpected Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> get(String url, {Map<String, dynamic>? query}) async {
    if (!await NetworkChecker.hasInternet()) {
      throw const NoInternetException();
    }

    try {
      if (kDebugMode) {
        debugPrint('GET Request → $url');
        debugPrint('Query: $query');
      }

      final response = await _dio.get(url, queryParameters: query);

      if (kDebugMode) {
        debugPrint('Response [${response.statusCode}] from $url');
        debugPrint('Data: ${response.data}');
      }

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('Dio Error → ${e.type}');
        debugPrint('Message: ${e.message}');
        debugPrint('URL: $url');
      }
      throw NetworkException.fromDioError(e);
    } catch (e) {
      if (kDebugMode) debugPrint('Unexpected Error: $e');
      rethrow;
    }
  }
}
