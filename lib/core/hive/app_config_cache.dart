import 'package:hive/hive.dart';

import '../../models/user_model.dart';

class AppConfigCache {
  static const String _boxName = 'appConfigBox';

  static const String _userModelKey = 'userModel';

  /// ✅ Save entire UserModel to Hive
  static Future<void> saveUserModel(UserModel user) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_userModelKey, user.toJson());
  }

  /// ✅ Get entire UserModel from Hive
  static Future<UserModel?> getUserModel() async {
    final box = await Hive.openBox(_boxName);
    final data = box.get(_userModelKey);
    if (data != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  /// ✅ Clear only user model data
  static Future<void> clearUserModel() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_userModelKey);
  }
}
