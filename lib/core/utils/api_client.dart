import 'package:coffeeya_admin/auth/repositories/auth.dart';
import 'package:coffeeya_admin/core/config/constant.dart';
import 'package:coffeeya_admin/core/models/response_model.dart';
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
            final response = await dio.request(
              e.requestOptions.path,
              data: e.requestOptions.data,
              queryParameters: e.requestOptions.queryParameters,
              options: Options(
                method: e.requestOptions.method,
                sendTimeout: e.requestOptions.sendTimeout,
                receiveTimeout: e.requestOptions.receiveTimeout,
                headers: {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${Global.getAccessToken()}',
                },
                responseType: e.requestOptions.responseType,
                contentType: e.requestOptions.contentType,
                validateStatus: e.requestOptions.validateStatus,
              ),
            );
            handler.resolve(response);
          }
        }
        handler.next(e);
      },
    ));
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
