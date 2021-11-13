import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:my_flutter_bloc_starter_project/app.dart';
import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;
import 'package:my_flutter_bloc_starter_project/shared/interceptors/attach_server_uri_interceptor.dart';
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

  Dio unAuthenticatedDio = initUnAuthenticatedDio(
    appSettingsRepository: appSettingsRepository,
  );
  Dio authenticatedDio = initAuthenticatedDio(
    appSettingsRepository: appSettingsRepository,
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

Dio initUnAuthenticatedDio({
  required AppSettingsRepository appSettingsRepository,
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
  ]);
  return _dio;
}

Dio initAuthenticatedDio({
  required AppSettingsRepository appSettingsRepository,
  required AuthenticationTokenRepository authenticationTokenRepository,
}) {
  final _dio = initUnAuthenticatedDio(
    appSettingsRepository: appSettingsRepository,
  );
  _dio.interceptors.add(AddAccessTokenInterceptor(
    authenticationTokenRepository: authenticationTokenRepository,
  ));
  return _dio;
}
