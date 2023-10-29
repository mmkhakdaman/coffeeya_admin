import 'package:coffeeya_admin/core/utils/api_client.dart';
import 'package:coffeeya_admin/product/models/category_model.dart';

class CategoryRepository {
  static Future<List<CategoryModel>> categories() async {
    return await ApiClient.get('api/admin/category/list').then((response) {
      return (response.data['data'] as List).map((e) => CategoryModel.fromJson(e)).toList();
    }).catchError((e) {
      return [];
    });
  }
}
