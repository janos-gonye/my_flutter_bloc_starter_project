import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:my_flutter_bloc_starter_project/app.dart';
import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;
import 'package:my_flutter_bloc_starter_project/user/user.dart';

void main() {
  Dio dio = initDio();
  runApp(
    MyStarterProjectApp(
      appSettingsRepository: AppSettingsRepository(
        secureStorage: const FlutterSecureStorage(),
        dio: dio,
      ),
      authenticationRepository: AuthenticationRepository(dio: dio),
      userRepository: UserRepository(dio: dio),
    ),
  );
}

Dio initDio() {
  final Dio _dio = Dio();
  _dio.options.connectTimeout = constants.connectionTimeout;
  _dio.options.receiveTimeout = constants.receiveTimeout;
  _dio.options.contentType = constants.contentType;
  return _dio;
}
