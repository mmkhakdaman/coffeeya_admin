class TableModel {
  int? id;
  String? title;
  bool? active;

  TableModel({
    this.id,
    this.title,
    this.active,
  });

  TableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    active = json['name'];
  }
}
