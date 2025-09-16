import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
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


}
