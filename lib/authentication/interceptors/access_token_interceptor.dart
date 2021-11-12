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
    String? accessToken = await authenticationTokenRepository.accessToken;
    // TODO: Handle if 'accessToken' is null
    assert(accessToken != null);
    debugPrint(accessToken);
    options.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    super.onRequest(options, handler);
  }
}
