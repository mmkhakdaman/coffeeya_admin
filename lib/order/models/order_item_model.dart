import 'package:coffeeya/product/models/product_model.dart';
import 'package:coffeeya/share/models/customer.dart';

class OrderItemModel {
  int? id;
  CustomerModel? customer;
  ProductModel? product;
  int? quantity;
  int? price;
  int? total;

  OrderItemModel({
    this.id,
    this.customer,
    this.product,
    this.quantity,
    this.price,
    this.total,
  });

  OrderItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'] != null ? CustomerModel.fromJson(json['customer']) : null;
    product = json['product'] != null ? ProductModel.fromJson(json['product']) : null;
    quantity = json['quantity'];
    price = json['price'];
    total = json['total'];
  }
}
