class AllStoreNameModel {
  bool? status;
  List<Stores>? stores;

  AllStoreNameModel({this.status, this.stores});

  AllStoreNameModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['stores'] != null) {
      stores = <Stores>[];
      json['stores'].forEach((v) {
        stores!.add(new Stores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (stores != null) {
      data['stores'] = stores!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stores {
  int? id;
  String? storeName;
  int? count;

  Stores({this.id, this.storeName, this.count});

  Stores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['store_name'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['store_name'] = storeName;
    data['count'] = count;
    return data;
  }
}
