class UserModel {
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

  UserModel(
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

  UserModel.fromJson(Map<String, dynamic> json) {
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
