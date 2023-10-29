import 'package:coffeeya_admin/product/models/product_mode.dart';

class CategoryModel {
  int id;
  String title;
  int order;
  bool? isActive;
  List<ProductModel>? products;

  CategoryModel({
    required this.id,
    required this.title,
    required this.order,
    this.isActive,
    this.products,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
      order: json['order'],
      isActive: json['is_active'],
      products: json['products'] != null ? (json['products'] as List).map((e) => ProductModel.fromJson(e)).toList() : null,
    );
  }
}
