import 'dart:io';

import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  bool _isUploading = false;

  bool get isUploading => _isUploading;

  File? _imageFile;
  bool _isLoading = false;

  String _statusMessage = '';

  // Getters to access state from the UI
  File? get imageFile => _imageFile;

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

    _isLoading = false;

    notifyListeners();
  }
}
