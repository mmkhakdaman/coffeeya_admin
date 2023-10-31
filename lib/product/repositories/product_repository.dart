import 'package:coffeeya_admin/core/models/response_model.dart';
import 'package:coffeeya_admin/core/utils/api_client.dart';

class ProductRepository {
  // create product
  static Future<ResponseModel> create({
    required Map<String, dynamic> data,
  }) async {
    return await ApiClient.post(
      '/api/admin/product/create',
      data: data,
    ).catchError((e) {
      throw e..data = data;
    });
  }
}
