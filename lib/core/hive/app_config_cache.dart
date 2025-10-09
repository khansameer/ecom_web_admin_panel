import 'package:hive/hive.dart';

class AppConfigCache {
  static const String _uidKey = 'uid';
  static const String _boxName = 'appConfigBox';
  static const String _accessTokenKey = 'accessToken';
  static const String _storeNameKey = 'storeName';
  static const String _versionCodeKey = 'versionCode';
  static const String _logoUrlKey = 'logoUrl';
  static const String _emailKey = 'email';
  static const String _mobileKey = 'mobile';
  static const String _name = 'name';

  static Future<void> saveConfig({
    required String accessToken,
    required String storeName,
    required String versionCode,
    required String logoUrl,
  }) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_accessTokenKey, accessToken);
    await box.put(_storeNameKey, storeName);
    await box.put(_versionCodeKey, versionCode);
    await box.put(_logoUrlKey, logoUrl);
  }


  static Future<void> saveUser({
    required String uid,
    required String name,
    required String mobile,
    required String email,
    required String photo,
  }) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_uidKey, uid);
    await box.put(_emailKey, email);
    await box.put(_name, name);
    await box.put(_logoUrlKey, photo);
    await box.put(_mobileKey, mobile);
  }

  /// Load all config
  static Future<Map<String, String>> getUserData() async {
    final box = await Hive.openBox(_boxName);
    return {
      'name': box.get(_name, defaultValue: ""),
      'email': box.get(_emailKey, defaultValue: ""),
      'mobile': box.get(_mobileKey, defaultValue: ""),
      'logoUrl': box.get(_logoUrlKey, defaultValue: ""),
      'id': box.get(_uidKey, defaultValue: ""),
    };
  }

  /// Load stored email or mobile
  static Future<String?> getStoredEmailOrMobile() async {
    final box = await Hive.openBox(_boxName);
    // Prefer email if available, else mobile
    String? email = box.get(_emailKey);
    if (email != null && email.isNotEmpty) return email;
    return box.get(_mobileKey);
  }

  static Future<String?> getName() async {
    final box = await Hive.openBox(_boxName);
    // Prefer email if available, else mobile
    String? name = box.get(_name);
    if (name != null && name.isNotEmpty) return name;
    return box.get(_emailKey);
  }
  static Future<String?> getID() async {
    final box = await Hive.openBox(_boxName);
    // Prefer email if available, else mobile
    //String? id = box.get(_uidKey);

    return box.get(_uidKey);
  }
  static Future<String?> getLogo() async {
    final box = await Hive.openBox(_boxName);
    // Prefer email if available, else mobile
    String logo = box.get(_logoUrlKey);
    if (logo.isNotEmpty) return logo;
    return box.get(_name);
  }


  /// Load all config
  static Future<Map<String, String>> loadConfig() async {
    final box = await Hive.openBox(_boxName);
    return {
      'accessToken': box.get(_accessTokenKey, defaultValue: ""),
      'storeName': box.get(_storeNameKey, defaultValue: ""),
      'versionCode': box.get(_versionCodeKey, defaultValue: ""),
      'logoUrl': box.get(_logoUrlKey, defaultValue: ""),
    };
  }
  static Future<String> getStoreName() async {
    final box = await Hive.openBox(_boxName);
    String storeName = box.get(_storeNameKey, defaultValue: "");
    return storeName.isNotEmpty ? storeName : "";
  }
  /// Clear config
  static Future<void> clearConfig() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_accessTokenKey);
    await box.delete(_storeNameKey);
    await box.delete(_versionCodeKey);
    await box.delete(_logoUrlKey);
  }
  static Future<void> clearAll() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_uidKey);
    await box.delete(_emailKey);
    await box.delete(_name);
    await box.delete(_mobileKey);
    await box.delete(_logoUrlKey);

    await box.delete(_accessTokenKey);
    await box.delete(_storeNameKey);
    await box.delete(_versionCodeKey);
  }

}
