class MenuModel {
  String? title;
  List<String>? image;
  MenuModel({this.title, this.image});
  MenuModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['image'] = this.image;
    return data;
  }
}
