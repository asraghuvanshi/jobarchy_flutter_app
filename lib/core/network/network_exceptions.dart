import 'package:dio/dio.dart';

import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);

  factory NetworkException.fromDioError(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const NetworkException('No Internet Connection');
    }

    if (error.response != null && error.response?.data is Map<String, dynamic>) {
      final data = error.response!.data as Map<String, dynamic>;
      final msg = data['message'] ?? 'Unknown error';
      return NetworkException(msg);
    }

    return NetworkException(error.message ?? 'Something went wrong');
  }
}

class NoInternetException extends NetworkException {
  const NoInternetException() : super('No Internet Connection');
}
