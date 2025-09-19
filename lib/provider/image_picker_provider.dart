import 'package:flutter/material.dart';

class ImagePickerProvider with ChangeNotifier {
  String? _imagePath;

  String? get imagePath => _imagePath;

  void setImagePath(String path) {
    _imagePath = path;
    notifyListeners();
  }

  void clearImage() {
    _imagePath = null;
    notifyListeners();
  }

  void resetState() {
    _imagePath = null;
    notifyListeners();
  }
}
