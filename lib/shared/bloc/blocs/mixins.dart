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

mixin TransformResponseErrorToStateMixin {
  ResponseError transformResponseErrorToState({
    required DioError error,
    List<String> fields = const [],
  }) {
    return ResponseError(
      message: 'error occurred',
      dioError: error,
      fieldErrors: {},
    );
  }
}
