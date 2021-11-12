import 'dart:async';

import 'package:dio/dio.dart';

import 'package:my_flutter_bloc_starter_project/app_settings/app_settings.dart';
import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;
import 'package:my_flutter_bloc_starter_project/login/login.dart';
import 'package:my_flutter_bloc_starter_project/registration/registration.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository({
    required this.unAuthenticatedDio,
    required this.authenticatedDio,
    required this.appSettingsRepository,
    required this.authenticationTokenRepository,
  });

  final AppSettingsRepository appSettingsRepository;
  final AuthenticationTokenRepository authenticationTokenRepository;
  final Dio unAuthenticatedDio;
  final Dio authenticatedDio;

  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    // TODO: To be implemented
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<String> registrate({
    required Username username,
    required Password password,
    required Email email,
  }) async {
    Uri? serverUri = await appSettingsRepository.serverUri;
    if (serverUri == null) {
      throw Exception('app settings server uri not configured');
    }
    serverUri = serverUri.replace(path: constants.apiPathAuthRegistration);
    final response = await unAuthenticatedDio.postUri(serverUri, data: {
      'username': username.value,
      'password': password.value,
      'email': email.value,
    });
    return response.data[constants.apiResponseMessageKey];
  }

  Future<void> logIn({
    required Username username,
    required Password password,
  }) async {
    Uri? serverUri = await appSettingsRepository.serverUri;
    if (serverUri == null) {
      throw Exception('app settings server uri not configured');
    }
    serverUri = serverUri.replace(path: constants.apiPathAuthLogin);
    final response = await unAuthenticatedDio.postUri(serverUri, data: {
      'username': username.value,
      'password': password.value,
    });
    Map<String, dynamic> body = response.data;
    await authenticationTokenRepository.write(
      accessToken: body['access'],
      refreshToken: body['refresh'],
    );
    _controller.add(AuthenticationStatus.authenticated);
  }

  Future<String> resetPassword({
    required Email email,
  }) async {
    Uri? serverUri = await appSettingsRepository.serverUri;
    if (serverUri == null) {
      throw Exception('app settings server uri not configured');
    }
    serverUri = serverUri.replace(path: constants.apiPathAuthResetPassword);
    final response = await unAuthenticatedDio.postUri(serverUri, data: {
      'email': email.value,
    });
    return response.data[constants.apiResponseMessageKey];
  }

  Future<String> changePassword({
    required Password currentPassword,
    required Password newPassword,
  }) async {
    Uri? serverUri = await appSettingsRepository.serverUri;
    if (serverUri == null) {
      throw Exception('app settings server uri not configured');
    }
    serverUri = serverUri.replace(path: constants.apiPathAuthChangePassword);
    final response = await authenticatedDio.patchUri(serverUri, data: {
      'current_password': currentPassword.value,
      'new_password': newPassword.value,
    });
    return response.data[constants.apiResponseMessageKey];
  }

  void logOut() async {
    await authenticationTokenRepository.clear();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();

  Future<String> changeEmail({required Email email}) async {
    Uri? serverUri = await appSettingsRepository.serverUri;
    if (serverUri == null) {
      throw Exception('app settings server uri not configured');
    }
    serverUri = serverUri.replace(path: constants.apiPathAuthChangeEmail);
    final response = await authenticatedDio.patchUri(serverUri, data: {
      'email': email.value,
    });
    return response.data[constants.apiResponseMessageKey];
  }

  Future<String> removeAccount() async {
    Uri? serverUri = await appSettingsRepository.serverUri;
    if (serverUri == null) {
      throw Exception('app settings server uri not configured');
    }
    serverUri = serverUri.replace(
      path: constants.apiPathAuthDeleteRegistration,
    );
    final response = await authenticatedDio.deleteUri(serverUri);
    return response.data[constants.apiResponseMessageKey];
  }
}
