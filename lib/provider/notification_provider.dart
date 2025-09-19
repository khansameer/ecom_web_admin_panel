import 'package:flutter/foundation.dart';
import 'package:neeknots/core/firebase/notification_storage.dart';

import '../core/firebase/local_notification.dart';

class NotificationProvider extends ChangeNotifier {
  List<LocalNotification> _list = [];
  bool _isLoading = true;

  List<LocalNotification> get list => _list;

  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _list = await NotificationStorage.getNotifications();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNotification(LocalNotification n) async {
    await NotificationStorage.saveNotification(n);
    await load();
    notifyListeners();
    // refresh after saving
  }

  Future<void> deleteNotification(int index) async {
    await NotificationStorage.deleteNotification(index);
    await load();
    notifyListeners();
  }

  Future<void> clearAll() async {
    await NotificationStorage.clearNotifications();

    await load();
    notifyListeners();
  }
}
