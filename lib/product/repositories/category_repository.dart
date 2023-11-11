import 'package:coffeeya_admin/core/models/response_model.dart';
import 'package:coffeeya_admin/core/utils/api_client.dart';
import 'package:coffeeya_admin/product/models/category_model.dart';

class CategoryRepository {
  static Future<ResponseModel> categories() async {
    List<CategoryModel> data = [];
    return await ApiClient.get('api/admin/category/list', queryParameters: {
      'with_product': true,
    }).then((value) {
      for (var json in value.json['data']) {
        data.add(CategoryModel.fromJson(json));
      }
      return value..data = data;
    }).catchError((e) {
      return e..data = data;
    });
  }

  static Future<ResponseModel> createCategory(Map<String, dynamic>? value) async {
    return await ApiClient.post('api/admin/category/create', data: value).then((response) {
      return response..data = CategoryModel.fromJson(response.json['data']);
    }).catchError((e) {
      throw e..data = {};
    });
  }
}
