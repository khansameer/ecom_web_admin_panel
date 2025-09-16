
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class SalesData {
  final String x;
  final double y;

  SalesData(this.x, this.y);
}
class NotificationModel {
  final String title;
  final String description;
  final String time;

  NotificationModel({
    required this.title,
    required this.description,
    required this.time,
  });
}

enum RequestStatus { pending, accepted, rejected }

class DashboardProvider with ChangeNotifier {
  int _currentIndex = 2;

  int get currentIndex => _currentIndex;

  String? _appbarTitle;

  String? get appbarTitle => _appbarTitle;
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  set isFetching(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setAppBarTitle(String? value) {
    _appbarTitle = value;
    notifyListeners();
  }



  String _filter = "Month";
  String get filter => _filter;

  void setFilter(String value) {
    _filter = value;
    notifyListeners();
  }

  List<SalesData> get salesData {
    if (_filter == "Today") {
      return [
        SalesData("9 AM", 5),
        SalesData("12 PM", 12),
        SalesData("3 PM", 8),
        SalesData("6 PM", 15),
        SalesData("9 PM", 10),
      ];
    } else if (_filter == "Week") {
      return [
        SalesData("Mon", 10),
        SalesData("Tue", 15),
        SalesData("Wed", 20),
        SalesData("Thu", 13),
        SalesData("Fri", 25),
        SalesData("Sat", 18),
        SalesData("Sun", 22),
      ];
    } else {
      return [
        SalesData('Jan', 9),
        SalesData('Feb', 11),
        SalesData('Mar', 14),
        SalesData('Apr', 10),
        SalesData('May', 21),
        SalesData('Jun', 23),
        SalesData('Jul', 18),
        SalesData('Aug', 22),
        SalesData('Sep', 28),
        SalesData('Oct', 26),
        SalesData('Nov', 27),
        SalesData('Dec', 31),
      ];
    }
  }

  final List<NotificationModel> _notifications = [
    NotificationModel(title: "Welcome", description: "Thanks for joining our app!", time: "10:00 AM"),
    NotificationModel(title: "Offer Alert", description: "Get 20% off on your next purchase.", time: "10:30 AM"),
    NotificationModel(title: "Reminder", description: "Don't forget your meeting at 3 PM.", time: "11:00 AM"),
    NotificationModel(title: "Update", description: "A new version of the app is available.", time: "11:30 AM"),
    NotificationModel(title: "Security", description: "Your password was changed successfully.", time: "12:00 PM"),
    NotificationModel(title: "Event", description: "Join our live session today at 6 PM.", time: "12:30 PM"),
    NotificationModel(title: "Survey", description: "Complete the survey and win rewards.", time: "1:00 PM"),
    NotificationModel(title: "News", description: "Check out the latest industry updates.", time: "1:30 PM"),
    NotificationModel(title: "Task", description: "You have 2 pending tasks to complete.", time: "2:00 PM"),
    NotificationModel(title: "Promo", description: "Special offer valid till midnight!", time: "2:30 PM"),
    NotificationModel(title: "Delivery", description: "Your package is out for delivery.", time: "3:00 PM"),
    NotificationModel(title: "Payment", description: "Your payment has been received.", time: "3:30 PM"),
    NotificationModel(title: "Message", description: "You have 3 unread messages.", time: "4:00 PM"),
    NotificationModel(title: "Like", description: "Someone liked your post.", time: "4:30 PM"),
    NotificationModel(title: "Comment", description: "You got a new comment.", time: "5:00 PM"),
    NotificationModel(title: "Friend Request", description: "John has sent you a friend request.", time: "5:30 PM"),
    NotificationModel(title: "System", description: "System maintenance at 11 PM tonight.", time: "6:00 PM"),
    NotificationModel(title: "Achievement", description: "You unlocked a new badge!", time: "6:30 PM"),
    NotificationModel(title: "Reminder", description: "Drink a glass of water now.", time: "7:00 PM"),
    NotificationModel(title: "Logout", description: "You have been logged out securely.", time: "7:30 PM"),
  ];

  List<NotificationModel> get notifications => _notifications;

  void resetTab() {
    _currentIndex = 0;
    _appbarTitle = null;
    _isFetching = false;
    _filter = "Month"; // 👈 default reset
    notifyListeners();
  }


}