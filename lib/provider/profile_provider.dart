import 'dart:io';

import 'package:flutter/material.dart';

import '../core/firebase/auth_service.dart';
import '../core/hive/app_config_cache.dart';

class ProfileProvider with ChangeNotifier {
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  bool _isUploading = false;

  bool get isUploading => _isUploading;

  File? _imageFile;

  File? get imageFile => _imageFile;
  bool _isLoading = false;

  String _statusMessage = '';

  bool get isLoading => _isLoading;

  String get statusMessage => _statusMessage;

  void setImageFilePath({required File img}) {
    _imageFile = img;
    notifyListeners();
  }

  final tetFName = TextEditingController();
  final tetLName = TextEditingController();
  final tetEmail = TextEditingController();
  final tetPhoneNo = TextEditingController();

  void resetState() {
    tetEmail.clear();
    tetFName.clear();
    tetLName.clear();
    tetPhoneNo.clear();

    _imageFile = null;
    _isFetching = false;
    _isUploading = false;
    _isLoading = false;
    _statusMessage = '';

    notifyListeners();
  }

  // Dispose controllers to prevent memory leaks
  @override
  void dispose() {
    tetEmail.dispose();
    tetFName.dispose();
    tetLName.dispose();
    tetPhoneNo.dispose();
    super.dispose();
  }

  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  Future<Map<String, dynamic>?> loadUserData() async {
    _userData?.clear();
    _isLoading = true;
    notifyListeners();
    String? storedEmailOrMobile = await AppConfigCache.getStoredEmailOrMobile();

    final userData = await AuthService().checkUserStatus(
      emailOrMobile: storedEmailOrMobile ?? '',
    );

    _userData = userData;

    _isLoading = false;
    notifyListeners();
    return _userData;
  }

  /// Optional: Clear user data
  void clearUserData() {
    _userData?.clear();
    notifyListeners();
  }
}
