import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);

  factory NetworkException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const NetworkException("Connection timeout");
      case DioExceptionType.sendTimeout:
        return const NetworkException("Send timeout");
      case DioExceptionType.receiveTimeout:
        return const NetworkException("Receive timeout");
      case DioExceptionType.badResponse:
        return NetworkException("Server error: ${error.response?.statusCode}");
      case DioExceptionType.cancel:
        return const NetworkException("Request cancelled");
      default:
        return const NetworkException("Something went wrong");
    }
  }

  const NetworkException.noInternet() : message = "No internet connection";
}
