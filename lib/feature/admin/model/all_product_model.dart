class AllProductModel {
  bool? status;
  int? count;
  List<Products>? products;

  AllProductModel({this.status, this.count, this.products});

  AllProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['count'] = count;
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
  String? version_code;
  String? accessToken;


  Products(
      {this.productId,
        this.storeName,
        this.id,
        this.name,
        this.imagePath,
        this.version_code,
        this.accessToken,
        this.imageId,
        this.createdDate});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    storeName = json['store_name'];
    id = json['id'];
    name = json['name'];
    imagePath = json['image_path'];
    version_code = json['version_code'];
    accessToken = json['accessToken'];
    imageId = json['image_id'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['store_name'] = storeName;
    data['id'] = id;
    data['accessToken'] = accessToken;
    data['version_code'] = version_code;
    data['name'] = name;
    data['image_path'] = imagePath;
    data['image_id'] = imageId;
    data['created_date'] = createdDate;
    return data;
  }
}
