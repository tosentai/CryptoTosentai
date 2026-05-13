import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class DioClient {
  DioClient() : _dio = _build();

  final Dio _dio;

  Dio get dio => _dio;

  static Dio _build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 25),
        headers: {
          'Accept': 'application/json',
          ApiConstants.apiKeyHeader: ApiConstants.apiKey,
        },
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          handler.next(e);
        },
      ),
    );

    return dio;
  }
}
