import 'package:flutter/widgets.dart';

import 'package:dio/dio.dart';

class RetryOnFailInterceptor extends Interceptor {
  RetryOnFailInterceptor({
    required this.dioInstance,
    this.retryOn = const [408, 502, 503, 504],
    this.maxRetries = 5,
    this.initialDelayMilliSeconds = 0,
    this.backoffMilliSeconds = 100,
  }) {
    delayMilliSeconds = initialDelayMilliSeconds;
  }

  final Dio dioInstance;
  final List<int> retryOn;
  final int maxRetries;
  final int backoffMilliSeconds;
  final int initialDelayMilliSeconds;
  int retries = 0;
  int delayMilliSeconds = 0;

  Future<Response<dynamic>> _retry(
    RequestOptions requestOptions,
  ) async {
    return dioInstance.request<dynamic>(
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
    if (retryOn.contains(err.response?.statusCode)) {
      try {
        retries++;
        if (retries < maxRetries + 1) {
          delayMilliSeconds =
              initialDelayMilliSeconds + backoffMilliSeconds * retries;
          debugPrint("╔╣ Retrying... #$retries");
          debugPrint("║  Delay: " + delayMilliSeconds.toString() + " ms");
          debugPrint("╚" + "═" * 48 + "╝");
          await Future.delayed(Duration(milliseconds: delayMilliSeconds));
          handler.resolve(await _retry(err.requestOptions));
          return;
        } else {
          retries = 0;
          delayMilliSeconds = initialDelayMilliSeconds;
          handler.next(err);
          return;
        }
      } on DioError catch (err) {
        handler.next(err);
        return;
      }
    }
    handler.next(err);
  }
}
