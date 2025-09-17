import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'local_notification.dart';

class NotificationStorage {
  static const String _boxName = 'notificationBox';
  static const String _key = 'notifications';

  /// Save a notification (insert latest first)
  static Future<void> saveNotification(LocalNotification n) async {
    final box = await Hive.openBox(_boxName);
    final List<String> existing = List<String>.from(box.get(_key) ?? []);

    existing.insert(0, jsonEncode(n.toMap())); // latest first
    await box.put(_key, existing);
  }

  /// Get all notifications
  static Future<List<LocalNotification>> getNotifications() async {
    final box = await Hive.openBox(_boxName);
    final List<String> jsonList = List<String>.from(box.get(_key) ?? []);
    return jsonList
        .map((e) => LocalNotification.fromMap(jsonDecode(e)))
        .toList();
  }

  /// Clear all notifications
  static Future<void> clearNotifications() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_key);
  }

  /// Delete a single notification by index
  static Future<void> deleteNotification(int index) async {
    final box = await Hive.openBox(_boxName);
    final List<String> existing = List<String>.from(box.get(_key) ?? []);

    if (index >= 0 && index < existing.length) {
      existing.removeAt(index);
      await box.put(_key, existing);
    }
  }
}
