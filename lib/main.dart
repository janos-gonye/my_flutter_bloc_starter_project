import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:my_flutter_bloc_starter_project/app.dart';
import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/shared/factory_funcs.dart';
import 'package:my_flutter_bloc_starter_project/shared/repositories/base_uri_configurer_repository.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secure_storage;

void main() async {
  const secureStorage = secure_storage.FlutterSecureStorage();
  const authenticationTokenRepository = AuthenticationTokenRepository(
    secureStorage: secureStorage,
  );

  Dio unAuthenticatedDio = buildUnAuthenticatedDio();
  Dio authenticatedDio = buildAuthenticatedDio(
    unAuthenticatedDio: unAuthenticatedDio,
    authenticationTokenRepository: authenticationTokenRepository,
  );

  const appSettingsRepository = AppSettingsRepository(
    secureStorage: secureStorage,
  );
  final baseURIConfigurerRepository = BaseURIConfigurerRepository(
    appSettingsRepository: appSettingsRepository,
    authenticatedDio: authenticatedDio,
    unAuthenticatedDio: unAuthenticatedDio,
  );

  // Must be called, otherwise
  //`appSettingsRepository.serverURI` throws an error.
  WidgetsFlutterBinding.ensureInitialized();
  await baseURIConfigurerRepository.reloadBaseURI();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
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
      baseURIConfigurerRepository: baseURIConfigurerRepository,
    ),
  );
}
