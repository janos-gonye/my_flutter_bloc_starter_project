import 'dart:async';

import 'package:dio/dio.dart';

import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;
import 'package:my_flutter_bloc_starter_project/login/login.dart';
import 'package:my_flutter_bloc_starter_project/registration/registration.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository({
    required this.unAuthenticatedDio,
    required this.authenticatedDio,
    required this.authenticationTokenRepository,
  });

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
    final response = await unAuthenticatedDio.post(
      constants.apiPathAuthRegistration,
      data: {
        'username': username.value,
        'password': password.value,
        'email': email.value,
      },
    );
    return response.data[constants.apiResponseMessageKey];
  }

  Future<void> logIn({
    required Username username,
    required Password password,
  }) async {
    final response = await unAuthenticatedDio.post(
      constants.apiPathAuthLogin,
      data: {
        'username': username.value,
        'password': password.value,
      },
    );
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
    final response = await unAuthenticatedDio.post(
      constants.apiPathAuthResetPassword,
      data: {
        'email': email.value,
      },
    );
    return response.data[constants.apiResponseMessageKey];
  }

  Future<String> changePassword({
    required Password currentPassword,
    required Password newPassword,
  }) async {
    final response = await authenticatedDio.patch(
      constants.apiPathAuthChangePassword,
      data: {
        'current_password': currentPassword.value,
        'new_password': newPassword.value,
      },
    );
    return response.data[constants.apiResponseMessageKey];
  }

  void logOut() async {
    await authenticationTokenRepository.clear();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();

  Future<String> changeEmail({required Email email}) async {
    final response = await authenticatedDio.patch(
      constants.apiPathAuthChangeEmail,
      data: {
        'email': email.value,
      },
    );
    return response.data[constants.apiResponseMessageKey];
  }

  Future<String> removeAccount() async {
    final response = await authenticatedDio.delete(
      constants.apiPathAuthDeleteRegistration,
    );
    return response.data[constants.apiResponseMessageKey];
  }
}
