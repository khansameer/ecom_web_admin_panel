import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../core/component/component.dart';
import '../core/hive/app_config_cache.dart';
import '../main.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../service/api_config.dart';
import '../service/gloable_status_code.dart';
import '../service/network_repository.dart';

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

  UserModel? _userData;

  UserModel? get userData => _userData;

  Future<void> loadUserData() async {
    UserModel? user = await AppConfigCache.getUserModel(); // await the future
    _isLoading = true;
    notifyListeners();
    try {
      final response = await callApi(
          method: HttpMethod.GET,
          url: '${ApiConfig.authAPi}/${user?.id??0}');

      if (globalStatusCode == 200) {
        _userData = UserModel.fromJson(json.decode(response));
      } else {
        showCommonDialog(
          showCancel: false,
          title: "Error",
          context: navigatorKey.currentContext!,
          content: errorMessage,
        );
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser() async {
    UserModel? user = await AppConfigCache.getUserModel(); // await the future
    _isLoading = true;
    notifyListeners();
    try {
     await callApi(
         method: HttpMethod.DELETE,
         url: '${ApiConfig.authAPi}/${user?.id??0}');

      if (globalStatusCode == 200) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            RouteName.loginScreen,
                (Route<dynamic> route) => false,
          );
        });
      } else {

      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  /// Optional: Clear user data
  void clearUserData() {
    _userData == null;
    notifyListeners();
  }
}
