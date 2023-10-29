import 'package:coffeeya_admin/auth/models/auth.dart';
import 'package:coffeeya_admin/core/config/constant.dart';
import 'package:coffeeya_admin/core/utils/api_client.dart';

class AuthRepository {
  static Future<bool> login({
    required String phone,
    required String password,
  }) async {
    return await ApiClient.post(
      '/api/admin/auth/login',
      data: {
        'phone': phone,
        'password': password,
      },
    ).then((response) {
      final login = LoginModel.fromJson(response.data);

      Global.setAccessToken(login.accessToken!);
      return true;
    }).catchError((e) {
      return false;
    });
  }

  static Future<bool> logout() async {
    return await ApiClient.post('/api/admin/auth/logout').then((response) {
      return true;
    }).catchError((e) {
      return false;
    });
  }

  static Future<bool> refresh() async {
    return await ApiClient.post('/api/admin/auth/refresh').then((response) {
      final login = LoginModel.fromJson(response.data);

      Global.setAccessToken(login.accessToken!);
      return true;
    }).catchError((e) {
      return false;
    });
  }
}
