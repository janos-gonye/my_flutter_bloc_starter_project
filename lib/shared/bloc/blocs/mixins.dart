import 'dart:io';

import 'package:dio/dio.dart';

class ResponseError {
  const ResponseError({
    required this.message,
    required this.dioError,
    required this.fieldErrors,
  });

  final String message;
  final DioError dioError;
  final Map<String, String> fieldErrors;
}

mixin HandleResponseErrorMixin {
  ResponseError handleResponseError({
    required DioError error,
    List<String> fields = const [],
  }) {
    String message = 'Connection Error';
    Map<String, String> fieldErrors = {};
    if (error.type == DioErrorType.connectTimeout ||
        error.type == DioErrorType.sendTimeout ||
        error.type == DioErrorType.receiveTimeout) {
      message = 'Connection Timed Out';
    } else if (error.type == DioErrorType.response &&
        error.response?.statusCode == 400 &&
        error.response?.data != null) {
      message = 'Invalid Values';
      Map<String, dynamic> body = error.response!.data;
      for (String field in fields) {
        if (body.containsKey(field) && (body[field] as List).isNotEmpty) {
          fieldErrors[field] = (body[field] as List).first.toString();
        }
      }
    } else if (error.type == DioErrorType.other) {
      message = 'Other Error';
      if (error.error is SocketException) {
        message = 'Socket Exception. Check Server Address';
      } else if (error.error is RangeError) {
        message = 'Server Address Not Configured';
      }
    }
    return ResponseError(
      message: message,
      dioError: error,
      fieldErrors: fieldErrors,
    );
  }
}
