import 'package:apple_shop/data/datasource/authentication_datasource.dart';
import 'package:apple_shop/di/di.dart';
import 'package:apple_shop/util/api_exception.dart';
import 'package:apple_shop/util/auth_manager.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAuthRepository {
  Future<Either<String, String>> register(
      String username, String pasword, String paswordConfirm);
  Future<Either<String, String>> login(String username, String pasword);
}

class AuthencticationRepository extends IAuthRepository {
  final IAuthenticationDatasource _datasource = locator.get();
  final SharedPreferences _sharedPref = locator.get();

  @override
  Future<Either<String, String>> register(
      String username, String pasword, String paswordConfirm) async {
    try {
      await _datasource.regester(username, pasword, paswordConfirm);
      return right('ثبت نام انجام شد');
    } on ApiException catch (ex) {
      return left(ex.message ?? 'خطا متن ندارد');
    }
  }

  @override
  Future<Either<String, String>> login(String username, String pasword) async {
    try {
      String token = await _datasource.login(username, pasword);
      if (token.isNotEmpty) {
        AuthManager.saveToken(token);
        return right('شما وارد شدید');
      } else {
        return left('خطایی در ورود پیش امد');
      }
    } on ApiException catch (ex) {
      return left('${ex.message}');
    }
  }
}
