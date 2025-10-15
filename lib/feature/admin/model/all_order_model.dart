class AllOrderModel {
  bool? status;
  int? count;
  List<Orders>? orders;

  AllOrderModel({this.status, this.count, this.orders});

  AllOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['count'] = count;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? orderId;
  int? id;
  String? title;
  int? status;
  String? value;
  String? createdDate;
  String? storeName;

  Orders(
      {this.orderId,
        this.id,
        this.title,
        this.status,
        this.value,
        this.createdDate,
        this.storeName});

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    id = json['id'];
    title = json['title'];
    status = json['status'];
    value = json['value'];
    createdDate = json['created_date'];
    storeName = json['store_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['id'] = id;
    data['title'] = title;
    data['status'] = status;
    data['value'] = value;
    data['created_date'] = createdDate;
    data['store_name'] = storeName;
    return data;
  }
}
