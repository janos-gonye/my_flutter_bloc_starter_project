import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:dio/dio.dart';

import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';

class AddAccessTokenInterceptor extends Interceptor {
  AddAccessTokenInterceptor({required this.authenticationTokenRepository})
      : super();

  final AuthenticationTokenRepository authenticationTokenRepository;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // An `AuthenticatedDio` instance only gets used after a login, therefore
    // `accessToken` can't be `null`. Yet, if it, for some reason, is `null`,
    // a `null` converted to string is just null, so a response saying invalid
    // token will come back.
    String? accessToken = await authenticationTokenRepository.accessToken;
    options.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    handler.next(options);
  }
}
