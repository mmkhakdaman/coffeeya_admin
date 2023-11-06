import 'package:coffeeya_admin/auth/repositories/auth_repository.dart';
import 'package:coffeeya_admin/core/utils/api_client.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'constant.dart';

class Token {
  static String? _accessToken;

  static void setAccessToken(String token) {
    final box = Hive.box(Constants.userBox);

    box.put('access_token', token);

    _accessToken = token;
  }

  static String? getAccessToken() {
    if (_accessToken == null) {
      final box = Hive.box(Constants.userBox);

      _accessToken = box.get('access_token');
    }
    return _accessToken;
  }

  static void removeAccessToken() {
    final box = Hive.box(Constants.userBox);

    box.delete('access_token');

    _accessToken = null;
  }

  static void logout() {
    AuthRepository.logout().catchError((e) {
      return e;
    });
    removeAccessToken();
  }

  static bool isLoggedIn() {
    return getAccessToken() != null;
  }
}

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = Token.getAccessToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      AuthRepository.refresh().then((value) {
        Token.setAccessToken(value.data!.accessToken!);

        ApiClient.dio().request(
          err.requestOptions.path,
          options: Options(
            headers: err.requestOptions.headers,
            method: err.requestOptions.method,
          ),
        );
      }).catchError((error) {
        Token.logout();
      });
    }

    super.onError(err, handler);
  }
}
