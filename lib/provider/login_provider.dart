import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';




class LoginProvider with ChangeNotifier {

  final bool _isFetching = false;

  bool get isFetching => _isFetching;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;



  void togglePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }



  final tetEmail = TextEditingController();
  final tetPassword = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    resetState();
  }




  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }






  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }





  void resetState() {

    tetEmail.clear();

    tetPassword.clear();

    _isLoading = false;
    _obscurePassword = true;

    notifyListeners();
  }
}
