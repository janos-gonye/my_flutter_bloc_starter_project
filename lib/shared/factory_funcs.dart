import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;
import 'package:my_flutter_bloc_starter_project/shared/interceptors/retry_on_fail_interceptor.dart';

Dio buildUnAuthenticatedDio() {
  final _dio = Dio();
  _dio.options.connectTimeout = constants.connectionTimeout;
  _dio.options.receiveTimeout = constants.receiveTimeout;
  _dio.options.contentType = constants.contentType;
  _dio.interceptors.addAll([
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
    RetryOnFailInterceptor(
      dioInstance: _dio,
      retryOn: constants.retryOnFailStatusCodes,
      maxRetries: constants.retryOnFailmaxRetries,
      initialDelayMilliSeconds: constants.retryOnFailinitialDelayMilliSeconds,
      backoffMilliSeconds: constants.retryOnFailbackoffMilliSeconds,
    ),
  ]);
  return _dio;
}

Dio buildAuthenticatedDio({
  required Dio unAuthenticatedDio,
  required AuthenticationTokenRepository authenticationTokenRepository,
}) {
  final _dio = Dio();
  _dio.options.connectTimeout = constants.connectionTimeout;
  _dio.options.receiveTimeout = constants.receiveTimeout;
  _dio.options.contentType = constants.contentType;
  _dio.interceptors.addAll([
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
    RetryOnFailInterceptor(
      dioInstance: _dio,
      retryOn: constants.retryOnFailStatusCodes,
      maxRetries: constants.retryOnFailmaxRetries,
      initialDelayMilliSeconds: constants.retryOnFailinitialDelayMilliSeconds,
      backoffMilliSeconds: constants.retryOnFailbackoffMilliSeconds,
    ),
    AddAccessTokenInterceptor(
      authenticationTokenRepository: authenticationTokenRepository,
    ),
    RefreshTokenInterceptor(
      authenticationTokenRepository: authenticationTokenRepository,
      unAuthenticatedDio: unAuthenticatedDio,
      authenticationDio: _dio,
    ),
  ]);
  return _dio;
}
