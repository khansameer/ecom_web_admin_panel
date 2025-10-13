import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/component/component.dart';
import '../core/firebase/auth_service.dart';
import '../main.dart';
import '../routes/app_routes.dart';
import '../service/api_config.dart';
import '../service/gloable_status_code.dart';
import '../service/network_repository.dart';
import 'login_provider.dart';

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
  Future<void> signup({required Map<String, dynamic> params}) async {
    _setLoading(true);
    try {
      final response = await callPostMethod(
        url: ApiConfig.authAPi,
        params:params,
        headers: null,
      );
      print('============${json.decode(response)}');
      if (globalStatusCode == 200) {
        showCommonDialog(
          title: "Success",
          onPressed: () {
            Timer(const Duration(milliseconds: 500), () async {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                RouteName.loginScreen,
                (Route<dynamic> route) => false,
              );

              final provider = Provider.of<LoginProvider>(
                navigatorKey.currentContext!,
                listen: false,
              );
              provider.resetState();
              // navigatorKey.currentContext?.read<LoginProvider>().resetState();
            });
          },
          context: navigatorKey.currentContext!,
          content:
              "Your account is successfully created. You can access it after 24 hours.",
        );
      }

      notifyListeners();
    } catch (e) {
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
