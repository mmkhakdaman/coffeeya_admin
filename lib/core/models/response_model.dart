import 'package:coffeeya/core/models/error.dart';

class ResponseModel<T> {
  final int statusCode;
  final dynamic json;
  late T data;
  int count = 0;
  ErrorModel? error;

  ResponseModel({this.statusCode = 400, required this.json}) {
    error = ErrorModel.fromJson(statusCode, json);
  }

  bool get hasError => statusCode >= 400;
}
