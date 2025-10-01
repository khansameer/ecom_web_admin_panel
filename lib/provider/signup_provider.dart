import 'package:flutter/material.dart';

import '../core/firebase/auth_service.dart';

class SignupProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  /// Set loading
  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  /// Signup
  Future<void> signup({
    required String email,
    required String storeName,
    required String websiteUrl,
    required String mobile,
    required String countryCode,
    required String logoUrl,
    required String name,
    required dynamic photo,
  }) async {

    _setLoading(true);
    try {
      _userData = await _authService.signupUser(
        email: email,
        logoUrl: logoUrl,
        storeName: storeName,
        websiteUrl: websiteUrl,
        countryCode:countryCode ,
        mobile: mobile,
        name: name,
        photo: photo,
      );
      notifyListeners();
    } catch (e) {

      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>?> verifyOtp({
    required String userID,
    required String enteredOtp,
  }) async {
    _setLoading(true);
    try {
      _userData = await _authService.verifyOtp(
        userID: userID,
        enteredOtp: enteredOtp,
      );
      notifyListeners();
      return _userData;
    } catch (e) {
      _setLoading(false);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }


  void resetAll() {
    _userData = null;
    _isLoading = false;

    // reset any other temporary variables here
    notifyListeners();
  }
}
