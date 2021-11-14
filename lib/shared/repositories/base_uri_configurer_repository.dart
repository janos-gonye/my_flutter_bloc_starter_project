import 'package:dio/dio.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';

class BaseURIConfigurerRepository {
  const BaseURIConfigurerRepository({
    required this.appSettingsRepository,
    required this.authenticatedDio,
    required this.unAuthenticatedDio,
  });

  final AppSettingsRepository appSettingsRepository;
  final Dio authenticatedDio;
  final Dio unAuthenticatedDio;

  Future<void> reloadBaseURI() async {
    final serverURI = await appSettingsRepository.serverURI;
    if (serverURI != null) {
      authenticatedDio.options.baseUrl = serverURI.toString();
      unAuthenticatedDio.options.baseUrl = serverURI.toString();
    }
  }
}
