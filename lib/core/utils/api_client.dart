import 'package:coffeeya_admin/core/config/constant.dart';
import 'package:coffeeya_admin/core/config/token.dart';
import 'package:coffeeya_admin/core/models/response_model.dart';
import 'package:dio/dio.dart';

class ApiClient {
  static Dio dio() {
    final dio = Dio();
    dio.options.baseUrl = Constants.baseUrl;
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    dio.interceptors.add(TokenInterceptor());
    return dio;
  }

  static Future<ResponseModel> get(String endpoint, {Map<String, dynamic>? queryParameters, ProgressCallback? onReceiveProgress}) {
    queryParameters = buildQueryParameters(queryParameters ?? {});
    return dio().get(endpoint, queryParameters: queryParameters, onReceiveProgress: onReceiveProgress).then((response) {
      return onResponse(response);
    }).catchError((error) {
      throw onError(error);
    });
  }

  static Future<ResponseModel> post(String endpoint,
      {Object? data, Map<String, dynamic>? queryParameters, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress}) {
    return dio()
        .post(endpoint, data: data, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress, queryParameters: queryParameters, cancelToken: cancelToken)
        .then((response) {
      return onResponse(response);
    }).catchError((error) {
      throw onError(error);
    });
  }

  static Future<ResponseModel> put(String endpoint, {Map<String, dynamic>? queryParameters, Object? data}) {
    return dio().put(endpoint, data: data, queryParameters: queryParameters).then((response) {
      return onResponse(response);
    }).catchError((error) {
      throw onError(error);
    });
  }

  static Future<ResponseModel> delete(String endpoint, {Object? data}) {
    return dio().delete(endpoint, data: data).then((response) {
      return onResponse(response);
    }).catchError((error) {
      throw onError(error);
    });
  }

  static ResponseModel onResponse(response) {
    return ResponseModel(statusCode: response.statusCode ?? 500, json: response.data);
  }

  static ResponseModel onError(error) {
    var response = error.response;
    var responseModel = ResponseModel(statusCode: response.statusCode ?? 500, json: response.data);
    // handelErrorAction(
    //   response: responseModel,
    // );
    return responseModel;
  }
}

Map<String, dynamic> buildQueryParameters(Map<String, dynamic> parameters) {
  final queryParameters = <String, dynamic>{};

  parameters.forEach((key, value) {
    if (value != null) {
      queryParameters[key] = value;
    }
  });

  return queryParameters;
}
