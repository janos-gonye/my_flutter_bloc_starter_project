import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:my_flutter_bloc_starter_project/app.dart';
import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;
import 'package:my_flutter_bloc_starter_project/user/user.dart';

void main() {
  Dio dio = initDio();
  const appSettingsRepository = AppSettingsRepository(
    secureStorage: FlutterSecureStorage(),
  );
  final authenticationRepository = AuthenticationRepository(
    dio: dio,
    appSettingsRepository: appSettingsRepository,
  );
  runApp(
    MyStarterProjectApp(
      appSettingsRepository: appSettingsRepository,
      authenticationRepository: authenticationRepository,
      userRepository: UserRepository(dio: dio),
    ),
  );
}

Dio initDio() {
  final Dio _dio = Dio();
  _dio.options.connectTimeout = constants.connectionTimeout;
  _dio.options.receiveTimeout = constants.receiveTimeout;
  _dio.options.contentType = constants.contentType;
  _dio.interceptors.add(initPrettyDioLogger());
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
