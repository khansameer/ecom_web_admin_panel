class PendingProductModel {
  bool? status;
  List<Products>? products;

  PendingProductModel({this.status, this.products});

  PendingProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? productId;
  String? storeName;
  int? id;
  String? name;
  String? imagePath;
  String? imageId;
  String? createdDate;

  Products(
      {this.productId,
        this.storeName,
        this.id,
        this.name,
        this.imagePath,
        this.imageId,
        this.createdDate});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    storeName = json['store_name'];
    id = json['id'];
    name = json['name'];
    imagePath = json['image_path'];
    imageId = json['image_id'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['store_name'] = storeName;
    data['id'] = id;
    data['name'] = name;
    data['image_path'] = imagePath;
    data['image_id'] = imageId;
    data['created_date'] = createdDate;
    return data;
  }
}
