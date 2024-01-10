import 'package:dio/dio.dart';

import 'auth_manager.dart';

class DioProvider {
  static Dio createDio() {
    Dio dio = Dio(BaseOptions(baseUrl: 'http://startflutter.ir/api/', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthManager.ReadAuth()}'
    }));

    return dio;
  }

  static Dio createDioWithoutHeader() {
    Dio dio = Dio(BaseOptions(
      baseUrl: 'http://startflutter.ir/api/',
    ));

    return dio;
  }
}
