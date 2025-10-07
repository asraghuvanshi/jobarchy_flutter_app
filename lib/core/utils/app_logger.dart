import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class AppLogger {
  static void logRequest(RequestOptions options) {
    developer.log(
      '''
 [REQUEST]
URL: ${options.uri}
METHOD: ${options.method}
HEADERS: ${options.headers}
DATA: ${options.data}
''',
      name: 'API',
    );
  }

  static void logResponse(Response response) {
    developer.log(
      '''
 [RESPONSE]
URL: ${response.requestOptions.uri}
STATUS: ${response.statusCode}
DATA: ${response.data}
''',
      name: 'API',
    );
  }

  static void logError(DioException error) {
    developer.log(
      '''
 [ERROR]
URL: ${error.requestOptions.uri}
TYPE: ${error.type}
MESSAGE: ${error.message}
RESPONSE: ${error.response?.data}
''',
      name: 'API',
      error: error,
    );
  }

  static void info(String message) {
    developer.log('ℹ$message', name: 'INFO');
  }

  static void warning(String message) {
    developer.log('$message', name: 'WARNING');
  }

  static void error(String message) {
    developer.log('$message', name: 'ERROR');
  }
}
