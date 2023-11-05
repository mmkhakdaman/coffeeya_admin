class AddressModel {
  int? id;
  String? phone;
  String? address;

  AddressModel({
    this.id,
    this.phone,
    this.address,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    address = json['address'];
  }
}
