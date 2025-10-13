class AdminContactListModel {
  bool? status;
  List<Contacts>? contacts;

  AdminContactListModel({this.status, this.contacts});

  AdminContactListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['contacts'] != null) {
      contacts = <Contacts>[];
      json['contacts'].forEach((v) {
        contacts!.add(new Contacts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.contacts != null) {
      data['contacts'] = this.contacts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contacts {
  int? contactId;
  int? id;
  String? storeName;
  String? name;
  String? email;
  String? mobile;
  String? message;
  String? fcmToken;
  String? createdDate;

  Contacts(
      {this.contactId,
        this.id,
        this.storeName,
        this.name,
        this.email,
        this.mobile,
        this.message,
        this.fcmToken,
        this.createdDate});

  Contacts.fromJson(Map<String, dynamic> json) {
    contactId = json['contact_id'];
    id = json['id'];
    storeName = json['store_name'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    message = json['message'];
    fcmToken = json['fcm_token'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact_id'] = this.contactId;
    data['id'] = this.id;
    data['store_name'] = this.storeName;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['message'] = this.message;
    data['fcm_token'] = this.fcmToken;
    data['created_date'] = this.createdDate;
    return data;
  }
}
