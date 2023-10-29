class ProductModel {
  int id;
  String title;
  String? description;
  int categoryId;
  int order;
  int price;
  String image;
  int? isActive;
  int? inStock;
  String createdAt;
  String updatedAt;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.order,
    required this.price,
    required this.image,
    this.isActive,
    this.inStock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      categoryId: json['category_id'],
      order: json['order'],
      price: json['price'],
      image: json['image'],
      isActive: json['is_active'],
      inStock: json['in_stock'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
