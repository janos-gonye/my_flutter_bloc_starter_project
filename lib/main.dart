import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:my_flutter_bloc_starter_project/app.dart';
import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/shared/factory_funcs.dart';
import 'package:my_flutter_bloc_starter_project/user/user.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secure_storage;

void main() {
  const secureStorage = secure_storage.FlutterSecureStorage();
  const authenticationTokenRepository = AuthenticationTokenRepository(
    secureStorage: secureStorage,
  );

  Dio unAuthenticatedDio = buildUnAuthenticatedDio();
  Dio authenticatedDio = buildAuthenticatedDio(
    authenticationTokenRepository: authenticationTokenRepository,
  );

  const appSettingsRepository = AppSettingsRepository(
    secureStorage: secureStorage,
  );

  final authenticationRepository = AuthenticationRepository(
    unAuthenticatedDio: unAuthenticatedDio,
    authenticatedDio: authenticatedDio,
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
