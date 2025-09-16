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
  final tetCurrentPassword = TextEditingController();
  final tetNewPassword = TextEditingController();
  final tetConfirmPassword = TextEditingController();


  bool _obscureCurrentPassword = true;

  bool get obscureCurrentPassword => _obscureCurrentPassword;
  void toggleCurrentPassword() {
    _obscureCurrentPassword = !_obscureCurrentPassword;
    notifyListeners();
  }

  bool _obscureNewPassword = true;

  bool get obscureNewPassword => _obscureNewPassword;
  void toggleNewPassword() {
    _obscureNewPassword = !_obscureNewPassword;
    notifyListeners();
  }

  bool _obscurConfirmPassword = true;

  bool get obscureConfirmPassword => _obscurConfirmPassword;
  void toggleConfirmPassword() {
    _obscurConfirmPassword = !_obscurConfirmPassword;
    notifyListeners();
  }



  @override
  void dispose() {
    resetState();
    tetEmail.dispose();
    tetPassword.dispose();
    tetCurrentPassword.dispose();
    tetNewPassword.dispose();
    tetConfirmPassword.dispose();
    super.dispose();
  }



  void resetState() {

    tetEmail.clear();

    tetCurrentPassword.clear();
    tetConfirmPassword.clear();
    tetNewPassword.clear();
    tetPassword.clear();

    _isLoading = false;
    _obscurePassword = true;

    notifyListeners();
  }
}
