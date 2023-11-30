import 'package:coffeeya/core/models/domain_model.dart';

class TenantModel {
  String id;
  String name;
  DomainModel? domain;

  TenantModel({
    required this.id,
    required this.name,
    required this.domain,
  });

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      id: json['id'],
      name: json['name'],
      domain: json['domain'] != null ? DomainModel.fromJson(json['domain']) : null,
    );
  }
}
