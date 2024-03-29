class GallaryDetailModel {
  List<ImageModel>? data;
  int? lastPage;

  GallaryDetailModel({
    this.data,
    this.lastPage,
  });

  GallaryDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ImageModel>[];
      json['data'].forEach((v) {
        data!.add(new ImageModel.fromJson(v));
      });
    }
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['last_page'] = this.lastPage;
    return data;
  }
}

class ImageModel {
  String? image;

  ImageModel({this.image});

  ImageModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}
