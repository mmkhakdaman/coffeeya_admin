import 'package:coffeeya_admin/core/models/response_model.dart';
import 'package:coffeeya_admin/core/utils/api_client.dart';
import 'package:coffeeya_admin/product/models/product_model.dart';

class ProductRepository {
  // create product
  static Future<ResponseModel> create({
    required Map<String, dynamic> data,
  }) async {
    return await ApiClient.post(
      '/api/admin/product/create',
      data: data,
    ).then((value) => value..data = ProductModel.fromJson(value.json['data'])).catchError((e) {
      throw e..data = data;
    });
  }

  static Future<ResponseModel> product({
    required String id,
  }) async {
    return await ApiClient.get('/api/admin/product/$id').then(
      (value) {
        return value..data = ProductModel.fromJson(value.json['data']);
      },
    ).catchError((e) {
      return e..data = {};
    });
  }

  static Future<ResponseModel> update(String id, {required Map<String, dynamic> data}) {
    return ApiClient.put('/api/admin/product/update/$id', data: data)
        .then(
      (value) => value..data = ProductModel.fromJson(value.json['data']),
    )
        .catchError(
      (e) {
        throw e..data = data;
      },
    );
  }
}
