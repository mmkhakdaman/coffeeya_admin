import 'package:coffeeya/auth/models/auth.dart';
import 'package:coffeeya/core/models/response_model.dart';
import 'package:coffeeya/core/utils/api_client.dart';

class AuthRepository {
  static Future<ResponseModel> login({
    required String phone,
    required String password,
  }) async {
    return await ApiClient.post(
      '/api/admin/auth/login',
      data: {
        'phone': phone,
        'password': password,
      },
    ).then((response) => response..data = LoginModel.fromJson(response.json)).catchError((error) {
      throw error;
    });
  }

  static Future<ResponseModel> logout() async {
    return await ApiClient.post('/api/admin/auth/logout');
  }

  static Future<ResponseModel> refresh() async {
    return await ApiClient.post('/api/admin/auth/refresh').then((response) => response..data = LoginModel.fromJson(response.json)).catchError((error) {
      throw error;
    });
  }
}
