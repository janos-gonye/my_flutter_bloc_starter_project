import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:my_flutter_bloc_starter_project/app.dart';
import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;
import 'package:my_flutter_bloc_starter_project/user/user.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secure_storage;

void main() {
  const secureStorage = secure_storage.FlutterSecureStorage();
  const authenticationTokenRepository = AuthenticationTokenRepository(
    secureStorage: secureStorage,
  );
  const appSettingsRepository = AppSettingsRepository(
    secureStorage: secureStorage,
  );

  Dio unAuthenticatedDio = initUnAuthenticatedDio();
  Dio authenticatedDio = initAuthenticatedDio(
    authenticationTokenRepository: authenticationTokenRepository,
  );

  final authenticationRepository = AuthenticationRepository(
    unAuthenticatedDio: unAuthenticatedDio,
    authenticatedDio: authenticatedDio,
    appSettingsRepository: appSettingsRepository,
    authenticationTokenRepository: authenticationTokenRepository,
  );
  runApp(
    MyStarterProjectApp(
      appSettingsRepository: appSettingsRepository,
      authenticationRepository: authenticationRepository,
      userRepository: UserRepository(
        unAuthenticatedDio: unAuthenticatedDio,
      ),
    ),
  );
}

Dio initUnAuthenticatedDio() {
  final _dio = Dio();
  _dio.options.connectTimeout = constants.connectionTimeout;
  _dio.options.receiveTimeout = constants.receiveTimeout;
  _dio.options.contentType = constants.contentType;
  _dio.interceptors.add(initPrettyDioLogger());
  return _dio;
}

Dio initAuthenticatedDio({
  required AuthenticationTokenRepository authenticationTokenRepository,
}) {
  final _dio = initUnAuthenticatedDio();
  _dio.interceptors.add(AddAccessTokenInterceptor(
    authenticationTokenRepository: authenticationTokenRepository,
  ));
  return _dio;
}

PrettyDioLogger initPrettyDioLogger() {
  return PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
  );
}
