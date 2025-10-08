
import 'package:flutter/cupertino.dart';

class AdminMenuProvider extends ChangeNotifier {
  // 🔹 Default selected menu
  String _selectedMenu = 'All Store';
  String get selectedMenu => _selectedMenu;

  // 🔹 Common menu items
  final List<String> _menuItems = ['All Store', 'Orders', 'Products'];
  List<String> get menuItems => _menuItems;

  // 🔹 Update selected menu and notify listeners
  void setSelectedMenu(String menu) {
    _selectedMenu = menu;
    notifyListeners();
  }
}