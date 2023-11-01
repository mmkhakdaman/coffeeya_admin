import 'package:coffeeya_admin/product/models/product_model.dart';

class CategoryModel {
  final int id;
  final String title;
  final int order;
  final bool? isActive;
  final List<ProductModel>? products;

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

  CategoryModel copyWith({
    int? id,
    String? title,
    int? order,
    bool? isActive,
    List<ProductModel>? products,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      products: products ?? this.products,
    );
  }
}
