class SubEventModel {
  String? title;
  String? time;

  SubEventModel({this.title, this.time});

  SubEventModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['time'] = this.time;
    return data;
  }
}
