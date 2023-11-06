class DomainModel {
  int id;
  String? tenantId;
  String? domain;

  DomainModel({
    required this.id,
    required this.tenantId,
    required this.domain,
  });

  factory DomainModel.fromJson(Map<String, dynamic> json) {
    return DomainModel(
      id: json['id'],
      tenantId: json['name'],
      domain: json['domain'],
    );
  }
}
