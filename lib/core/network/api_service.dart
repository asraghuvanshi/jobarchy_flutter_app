import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jobarchy_flutter_app/core/network/dio_interceptor.dart';
import 'package:jobarchy_flutter_app/core/network/network_exceptions.dart';
import 'package:jobarchy_flutter_app/core/utils/environment.dart';
import 'network_checker.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    // Global interceptor
    _dio.interceptors.add(AppInterceptor());

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint('[DIO] $obj'),
        ),
      );
    }

    //  set a reasonable timeout
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
  }

  // -----------------------------------------------------------------
  // 1. JSON POST
  // -----------------------------------------------------------------
  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> params,
  ) async {
    if (!await NetworkChecker.hasInternet()) {
      throw const NoInternetException();
    }

    final fullUrl = '${Environment.baseUrl}$url';
    try {
      if (kDebugMode) {
        debugPrint('POST Request → $fullUrl');
        debugPrint('Body: $params');
      }

      final response = await _dio.post(fullUrl, data: params);

      if (kDebugMode) {
        debugPrint('Response [${response.statusCode}] from $fullUrl');
        debugPrint('Data: ${response.data}');
      }

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('Dio Error → ${e.type}');
        debugPrint('Message: ${e.message}');
        debugPrint('URL: $fullUrl');
      }
      throw NetworkException.fromDioError(e);
    } catch (e) {
      if (kDebugMode) debugPrint('Unexpected Error: $e');
      rethrow;
    }
  }

  // -----------------------------------------------------------------
  // 2. GET
  // -----------------------------------------------------------------
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, dynamic>? query,
  }) async {
    if (!await NetworkChecker.hasInternet()) {
      throw const NoInternetException();
    }

    final fullUrl = '${Environment.baseUrl}$url';
    try {
      if (kDebugMode) {
        debugPrint('GET Request → $fullUrl');
        debugPrint('Query: $query');
      }

      final response = await _dio.get(fullUrl, queryParameters: query);

      if (kDebugMode) {
        debugPrint('Response [${response.statusCode}] from $fullUrl');
        debugPrint('Data: ${response.data}');
      }

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('Dio Error → ${e.type}');
        debugPrint('Message: ${e.message}');
        debugPrint('URL: $fullUrl');
      }
      throw NetworkException.fromDioError(e);
    } catch (e) {
      if (kDebugMode) debugPrint('Unexpected Error: $e');
      rethrow;
    }
  }

  // -----------------------------------------------------------------
  // 3. DELETE
  // -----------------------------------------------------------------
  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, dynamic>? query,
  }) async {
    if (!await NetworkChecker.hasInternet()) {
      throw const NoInternetException();
    }

    final fullUrl = '${Environment.baseUrl}$url';

    try {
      if (kDebugMode) {
        debugPrint('DELETE Request → $fullUrl');
        debugPrint('Query: $query');
      }

      final response = await _dio.delete(fullUrl, queryParameters: query);

      if (kDebugMode) {
        debugPrint('Response [${response.statusCode}] from $fullUrl');
        debugPrint('Data: ${response.data}');
      }

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('Dio Error → ${e.type}');
        debugPrint('Message: ${e.message}');
        debugPrint('URL: $fullUrl');
      }
      throw NetworkException.fromDioError(e);
    } catch (e) {
      if (kDebugMode) debugPrint('Unexpected Error: $e');
      rethrow;
    }
  }

  // -----------------------------------------------------------------
  // 3. NEW: MULTIPART POST (images + fields)
  // -----------------------------------------------------------------
  /// Sends a multipart request.
  ///
  /// * `url` – **relative** path, e.g. `/v1/posts`.
  /// * `fields` – key/value map of **text** fields (`title`, `description`, `country` …).
  /// * `files` – list of **File** objects that will be sent under the key `files`.
  /// * `filesFieldName` – defaults to `"files"` (matches Postman).
  ///
  Future<Map<String, dynamic>> postMultipart({
    required String url,
    required Map<String, String> fields,
    required List<File> files,
    String filesFieldName = 'image', // ← CHANGED HERE
  }) async {
    if (!await NetworkChecker.hasInternet()) {
      throw const NoInternetException();
    }

    final fullUrl = '${Environment.baseUrl}$url';

    if (kDebugMode) {
      debugPrint('POST Multipart → $fullUrl');
      debugPrint('Fields: $fields');
      debugPrint(
        'Files (${files.length}): ${files.map((f) => f.path).toList()}',
      );
    }

    // Build FormData
    final formData = FormData.fromMap({
      ...fields,
      filesFieldName: await Future.wait(
        files.map((file) async {
          final fileName = file.path.split(Platform.pathSeparator).last;
          return MultipartFile.fromFile(file.path, filename: fileName);
        }),
      ),
    });

    try {
      final response = await _dio.post(
        fullUrl,
        data: formData,
        options: Options(headers: {}),
      );

      if (kDebugMode) {
        debugPrint('Multipart Response [${response.statusCode}] from $fullUrl');
        debugPrint('Data: ${response.data}');
      }

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('Multipart Dio Error → ${e.type}');
        debugPrint('Message: ${e.message}');
        debugPrint('URL: $fullUrl');
      }
      throw NetworkException.fromDioError(e);
    } catch (e) {
      if (kDebugMode) debugPrint('Multipart Unexpected Error: $e');
      rethrow;
    }
  }
}
