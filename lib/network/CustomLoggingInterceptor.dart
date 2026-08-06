

import 'package:dio/dio.dart';

class CustomLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('➡️ [Request]');
    print('URL: ${options.uri}');
    print('Method: ${options.method}');
    print('Headers: ${options.headers}');
    print('Body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ [Response]');
    print('Status Code: ${response.statusCode}');
    print('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ [Error]');
    print('Message: ${err.message}');
    print('Response: ${err.response?.data}');
    super.onError(err, handler);
  }
}
