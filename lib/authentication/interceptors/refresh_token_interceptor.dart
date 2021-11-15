import 'package:dio/dio.dart';

import 'package:my_flutter_bloc_starter_project/authentication/authentication.dart';
import 'package:my_flutter_bloc_starter_project/constants.dart' as constants;

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor({
    required this.authenticationTokenRepository,
    required this.unAuthenticatedDio,
    required this.authenticationDio,
  }) : super();

  final AuthenticationTokenRepository authenticationTokenRepository;
  final Dio unAuthenticatedDio;
  final Dio authenticationDio;

  Future<String> _refreshToken(String refreshToken) async {
    final response = await unAuthenticatedDio.post(
      constants.apiPathAuthTokenRefresh,
      data: {
        'refresh': refreshToken,
      },
    );
    return response.data['access'];
  }

  Future<Response<dynamic>> _retry(
    RequestOptions requestOptions,
  ) async {
    return authenticationDio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      String? refreshToken = await authenticationTokenRepository.refreshToken;
      if (refreshToken != null) {
        try {
          final newAccessToken = await _refreshToken(refreshToken);
          await authenticationTokenRepository.write(
            accessToken: newAccessToken,
          );
          handler.resolve(await _retry(err.requestOptions));
          return;
        } on DioError catch (err) {
          handler.next(err);
          return;
        }
      }
    }
    handler.next(err);
  }
}
