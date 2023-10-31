import 'package:coffeeya_admin/core/models/response_model.dart';
import 'package:coffeeya_admin/core/utils/api_client.dart';
import 'package:coffeeya_admin/product/models/category_model.dart';

class CategoryRepository {
  static Future<ResponseModel> categories() async {
    var response = await ApiClient.get('api/admin/category/list').catchError((e) {
      return e..data = List<CategoryModel>.empty();
    });

    if (response.statusCode == 200) {
      List<CategoryModel> data = [];
      for (var json in response.json['data']) {
        data.add(CategoryModel.fromJson(json));
      }
      response.data = data;
    }

    return response;
  }

  static Future<CategoryModel?> createCategory(Map<String, dynamic>? value) async {
    return await ApiClient.post('api/admin/category/create', data: value).then((response) {
      return CategoryModel.fromJson(response.data['data']);
    }).catchError((e) {
      throw e;
    });
  }
}
