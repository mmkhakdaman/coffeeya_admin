import 'package:hive/hive.dart';

class Constants {
  static const baseUrl = "http://test.coffeeya.ir/";
  static const userBox = "user";
  static const configBox = "config";
}

class Global {
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
}
