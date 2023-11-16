import 'package:coffeeya_admin/order/models/order_item_model.dart';
import 'package:coffeeya_admin/share/models/address_model.dart';
import 'package:coffeeya_admin/share/models/customer.dart';
import 'package:coffeeya_admin/share/models/table_model.dart';

class OrderModel {
  int? id;
  CustomerModel? customer;
  TableModel? table;
  bool? isDelivery;
  AddressModel? address;
  bool? isPackaging;
  String? description;
  String? status;
  DateTime? pendingAt;
  DateTime? confirmedAt;
  DateTime? completedAt;
  DateTime? cancelledAt;
  int? postCost;
  int? orderPrice;
  int? totalPrice;
  List<OrderItemModel>? items;

  OrderModel({
    this.id,
    this.customer,
    this.table,
    this.isDelivery,
    this.address,
    this.isPackaging,
    this.description,
    this.status,
    this.pendingAt,
    this.confirmedAt,
    this.completedAt,
    this.cancelledAt,
    this.postCost,
    this.orderPrice,
    this.totalPrice,
    this.items,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'] != null ? CustomerModel.fromJson(json['customer']) : null;
    table = json['table'] != null ? TableModel.fromJson(json['table']) : null;
    isDelivery = json['is_delivery'];
    address = json['address'] != null ? AddressModel.fromJson(json['address']) : null;
    isPackaging = json['is_packaging'];
    description = json['description'];
    status = json['status'];
    pendingAt = json['pending_at'] != null ? DateTime.parse(json['pending_at']) : null;
    confirmedAt = json['confirmed_at'] != null ? DateTime.parse(json['confirmed_at']) : null;
    completedAt = json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null;
    cancelledAt = json['cancelled_at'] != null ? DateTime.parse(json['cancelled_at']) : null;
    postCost = json['post_cost'];
    orderPrice = json['order_price'];
    totalPrice = json['total_price'];
    if (json['items'] != null) {
      items = <OrderItemModel>[];
      json['items'].forEach((v) {
        items!.add(OrderItemModel.fromJson(v));
      });
    }
  }
}
