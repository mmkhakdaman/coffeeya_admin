class CustomerModel {
  int? id;
  String? phone;
  String? name;

  CustomerModel({
    this.id,
    this.phone,
    this.name,
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    name = json['name'];
  }
}
