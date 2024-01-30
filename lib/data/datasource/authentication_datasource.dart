// ignore_for_file: deprecated_member_use

import 'package:apple_shop/util/api_exception.dart';
import 'package:apple_shop/util/auth_manager.dart';
import 'package:apple_shop/util/dio_provider.dart';
import 'package:dio/dio.dart';

abstract class IAuthenticationDatasource {
  Future<void> regester(String username, String pasword, String paswordConfirm);
  Future<String> login(String username, String pasword);
}

class AuthenticationRemote implements IAuthenticationDatasource {
  final Dio _dio = DioProvider.createDioWithoutHeader();

  @override
  Future<void> regester(
      String username, String pasword, String paswordConfirm) async {
    try {
      final response = await _dio.post('collections/users/records', data: {
        'username': username,
        'name': username,
        'pasword': pasword,
        'paswordConfirm': paswordConfirm,
      });
      if (response.statusCode == 200) {
        login(username, pasword);
      }
    } on DioError catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message'],
          response: ex.response);
    } catch (ex) {
      throw ApiException(0, 'unknown Error');
    }
  }

  @override
  Future<String> login(String username, String pasword) async {
    try {
      var response =
          await _dio.post('collections/users/auth-with-password', data: {
        'identity': username,
        'pasword': pasword,
      });
      if (response.statusCode == 200) {
        AuthManager.saveId(response.data?['record']['id']);
        AuthManager.saveToken(response.data?['token']);
        return response.data?['token'];
      }
    } on DioError catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown Error');
    }
    return '';
  }
}
