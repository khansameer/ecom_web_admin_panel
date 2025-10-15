class AllUserModel {
  bool? status;
  int? count;
  List<Users>? users;

  AllUserModel({this.status, this.count, this.users});

  AllUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['count'] = count;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? id;
  String? storeName;
  String? email;
  String? mobile;
  String? name;
  String? accessToken;
  String? versionCode;
  String? logoUrl;
  String? countryCode;
  String? fcmToken;
  int? activeStatus;
  String? createdAt;
  String? otp;

  Users(
      {this.id,
        this.storeName,
        this.email,
        this.mobile,
        this.name,
        this.accessToken,
        this.versionCode,
        this.logoUrl,
        this.countryCode,
        this.fcmToken,
        this.activeStatus,
        this.createdAt,
        this.otp});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['store_name'];
    email = json['email'];
    mobile = json['mobile'];
    name = json['name'];
    accessToken = json['accessToken'];
    versionCode = json['version_code'];
    logoUrl = json['logo_url'];
    countryCode = json['country_code'];
    fcmToken = json['fcm_token'];
    activeStatus = json['active_status'];
    createdAt = json['created_at'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['store_name'] = storeName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['name'] = name;
    data['accessToken'] = accessToken;
    data['version_code'] = versionCode;
    data['logo_url'] = logoUrl;
    data['country_code'] = countryCode;
    data['fcm_token'] = fcmToken;
    data['active_status'] = activeStatus;
    data['created_at'] = createdAt;
    data['otp'] = otp;
    return data;
  }
}
