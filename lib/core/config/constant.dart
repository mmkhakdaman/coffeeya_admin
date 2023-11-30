import 'package:coffeeya/core/config/token.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class Constants {
  static String? _baseUrl;
  static const userBox = "user";
  static const configBox = "config";

  static get baseUrl => getBaseUrl();

  static String getBaseUrl() {
    if (_baseUrl == null) {
      final box = Hive.box(Constants.configBox);

      _baseUrl = box.get('base_url');
    }
    if (_baseUrl == null) {
      Token.removeAccessToken();
      Global.context?.goNamed('auth');
    }

    return _baseUrl!;
  }

  static setBaseUrl(url) {
    final box = Hive.box(Constants.configBox);

    box.put('base_url', url);

    _baseUrl = url;
  }
}

class Global {
  static BuildContext? context;
}
