import 'dart:developer';

import 'package:coffeeya/core/models/response_model.dart';
import 'package:coffeeya/core/utils/api_client.dart';
import 'package:coffeeya/product/models/product_model.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  // create product
  static Future<ResponseModel> create({
    required FormData data,
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

  static Future<ResponseModel> update(String id, {required FormData data}) async {
    return await ApiClient.put('/api/admin/product/update/$id', data: data).then(
      (value) => value..data = ProductModel.fromJson(value.json['data']),
    );
  }

  static Future<ResponseModel> toggleActive({required ProductModel product}) async {
    return await ApiClient.put('/api/admin/product/toggle-stock/${product.id}').then(
      (value) {
        product = ProductModel.fromJson(value.json['data']);
        return value..data = product;
      },
    ).catchError(
      (e) {
        inspect(e);
        throw e;
      },
    );
  }
}
