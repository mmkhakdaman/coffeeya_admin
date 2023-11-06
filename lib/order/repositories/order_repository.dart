import 'dart:developer';

import 'package:coffeeya_admin/core/models/response_model.dart';
import 'package:coffeeya_admin/core/utils/api_client.dart';
import 'package:coffeeya_admin/order/models/order_model.dart';

class OrderRepository {
  static Future<ResponseModel> orders({
    String? status,
    int? page,
    int? perPage,
  }) async {
    return await ApiClient.get('api/admin/orders', queryParameters: {
      if (status != null) 'status': status,
      if (page != null) 'page': page,
      if (perPage != null) 'per_page': perPage,
    }).then((value) {
      List<OrderModel> data = [];

      for (var json in value.json['data']) {
        data.add(OrderModel.fromJson(json));
      }

      return value..data = data;
    }).catchError((e) {
      inspect(e);
      return e..data = [] as List<OrderModel>;
    });
  }

  static Future<ResponseModel> updateOrder({int? id, required String status}) async {
    return await ApiClient.put(
      'api/admin/orders/$id',
      data: {
        'status': status,
      },
    ).then((value) {
      return value..data = OrderModel.fromJson(value.json['data']);
    }).catchError((e) {
      return e;
    });
  }
}
