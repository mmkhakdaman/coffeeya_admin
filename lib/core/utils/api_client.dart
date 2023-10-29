import 'package:coffeeya_admin/auth/repositories/auth.dart';
import 'package:coffeeya_admin/core/config/constant.dart';
import 'package:dio/dio.dart';

class ApiClient {
  static Dio dio() {
    final dio = Dio();
    dio.options.baseUrl = Constants.baseUrl;
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Global.getAccessToken()}',
    };
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          if (await AuthRepository.refresh()) {
            handler.next(e);
          }
        }
        handler.next(e);
      },
    ));
    return dio;
  }

  static Future<Response> get(String path) async {
    return await dio().get(path).catchError((e) {
      throw e;
    });
  }

  static Future<Response> post(
    String path, {
    dynamic data,
  }) async {
    return await dio().post(path, data: data).then((value) {
      return value;
    }).catchError((e) {
      throw e;
    });
  }

  static Future<Response> put(
    String path, {
    dynamic data,
  }) async {
    return await dio().put(path, data: data);
  }

  static Future<Response> delete(String path) async {
    return await dio().delete(path);
  }
}
