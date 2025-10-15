import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/main.dart';

import '../core/hive/app_config_cache.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../service/api_config.dart';
import '../service/gloable_status_code.dart';
import '../service/network_repository.dart';

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

  final tetFullName = TextEditingController();
  final tetEmail = TextEditingController();
  final tetMessage = TextEditingController();
  TextEditingController tetPhone = TextEditingController();
  TextEditingController tetCountryCodeController = TextEditingController(
    text: "+1",
  );

  final tetStoreName = TextEditingController();
  final tetWebsiteUrl = TextEditingController();
  final tetLogoUrl = TextEditingController();
  final tetPassword = TextEditingController();
  final tetCurrentPassword = TextEditingController();
  final tetNewPassword = TextEditingController();
  final tetConfirmPassword = TextEditingController();
  final tetOTP = TextEditingController();

  bool _obscureCurrentPassword = true;

  bool get obscureCurrentPassword => _obscureCurrentPassword;

  void toggleCurrentPassword() {
    _obscureCurrentPassword = !_obscureCurrentPassword;
    notifyListeners(); // 🔥 must be present
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

  String? _logoUrl;

  String? get logoUrl => _logoUrl;

  void setAppLogo(String value) {
    _logoUrl = value;
    notifyListeners();
  }

  @override
  void dispose() {
    tetFullName.dispose();
    tetEmail.dispose();
    tetPhone.dispose();
    tetStoreName.dispose();
    tetWebsiteUrl.dispose();
    tetPassword.dispose();
    tetCurrentPassword.dispose();
    tetCountryCodeController.dispose();
    tetNewPassword.dispose();
    tetConfirmPassword.dispose();
    tetMessage.dispose();
    tetLogoUrl.dispose();

    _timer?.cancel();
    super.dispose();
  }

  void resetState() {
    tetEmail.clear();

    tetFullName.clear();
    tetEmail.clear();
    tetPhone.clear();
    tetStoreName.clear();
    tetWebsiteUrl.clear();
    tetPassword.clear();
    tetCurrentPassword.clear();
    tetNewPassword.clear();
    tetConfirmPassword.clear();
    tetOTP.clear();
    tetMessage.clear();
    tetLogoUrl.clear();
    _isLoading = false;
    _obscurePassword = true;

    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  //final AuthService _authService = AuthService();

  Future<void> login({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
     await callApi(
        url: ApiConfig.loginAPi,
       method: HttpMethod.POST,
        body: body,
        headers: null,
      );


      if (globalStatusCode == 200) {
        generateOtp(body: body);
      }
      else
        {
          showCommonDialog(
            showCancel: false,
            title: "Error",
            confirmText: "Close",
            context: navigatorKey.currentContext!,
            content: errorMessage,
          );
        }
      notifyListeners();
    } catch (e) {
      showCommonDialog(
        showCancel: false,
        title: "Error",
        confirmText: "Close",
        context: navigatorKey.currentContext!,
        content: errorMessage,
      );
      _setLoading(false);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> generateOtp({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.generateOtpAPI,
        method: HttpMethod.POST,
        body: body,
        headers: null,
      );

      print('============${json.decode(response)}');
      if (globalStatusCode == 200) {
        Map<String, dynamic> data = {
          "email": body['email'],
          "mobile": body['mobile'],
        };
        navigatorKey.currentState?.pushNamed(
          RouteName.otpVerificationScreen,
          arguments: data,
        );
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
      _setLoading(false);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkStatus({int? id}) async {
    _setLoading(true);
    try {
      final response = await callApi(
          method: HttpMethod.GET,
          url: '${ApiConfig.authAPi}/$id');

      if (globalStatusCode == 200) {
        UserModel user = UserModel.fromJson(json.decode(response));
        if (user.id != null && user.activeStatus == 1) {
          await AppConfigCache.saveUserModel(user);
          setAppLogo(user.logoUrl ?? '');
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            RouteName.dashboardScreen,
            (Route<dynamic> route) => false,
          );
        } else {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            RouteName.inactiveAccountScreen,
            (Route<dynamic> route) => false,
          );
        }
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
      _setLoading(false);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOtp({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        url: ApiConfig.verifyOtpAPI,
        method: HttpMethod.POST,
        body: body,
        headers: null,
      );

      print('============${json.decode(response)}');
      if (globalStatusCode == 200) {
        UserModel user = UserModel.fromJson(json.decode(response));
        await AppConfigCache.saveUserModel(user);

        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteName.dashboardScreen,
          (Route<dynamic> route) => false,
        );
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
      _setLoading(false);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void resetAll() {
    // _userData = null;

    _isLoading = false;

    _obscurePassword = true;
    _obscureCurrentPassword = true;
    _obscureNewPassword = true;
    _obscurConfirmPassword = true;

    // Clear all text controllers
    tetFullName.clear();
    tetEmail.clear();
    tetPhone.clear();
    tetStoreName.clear();
    tetWebsiteUrl.clear();
    tetPassword.clear();
    tetCurrentPassword.clear();
    tetNewPassword.clear();
    tetNewPassword.clear();
    tetMessage.clear();

    notifyListeners();
  }

  Future<void> addContactUsData({required Map<String, dynamic> body}) async {
    _setLoading(true);
    try {
      final response = await callApi(
        method: HttpMethod.POST,
        url: ApiConfig.contactUs,
        body: body,
        headers: null,
      );

      print('============${json.decode(response)}');
      if (globalStatusCode == 200) {

        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          RouteName.dashboardScreen,
              (Route<dynamic> route) => false,
        );
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
      _setLoading(false);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  bool _canResend = false;
  int _secondsRemaining = 10;
  Timer? _timer;

  bool get canResend => _canResend;

  int get secondsRemaining => _secondsRemaining;

  void startResendTimer() {
    _canResend = false;
    _secondsRemaining = 10;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        _secondsRemaining--;
      } else {
        _timer?.cancel();
        _canResend = true;
      }
      notifyListeners();
    });

    notifyListeners();
  }

  Future<void> resendOtp({required Map<String, dynamic> body}) async {
    if (!_canResend) return;
    _setLoading(true);
    notifyListeners();

    try {
      // 🔹 Your actual resend API call here
      await Future.delayed(
        const Duration(seconds: 2),
      ); // simulate network delay
      final response = await callApi(
        method: HttpMethod.POST,
        url: ApiConfig.generateOtpAPI,
        body: body,
        headers: null,
      );

      print('============${json.decode(response)}');
      if (globalStatusCode == 200) {
        Map<String, dynamic> data = {
          "email": body['email'],
          "mobile": body['mobile'],
        };
        navigatorKey.currentState?.pushNamed(
          RouteName.otpVerificationScreen,
          arguments: data,
        );
      }

      notifyListeners();
      _startNewCycle();
    } catch (e) {
      debugPrint("Resend OTP failed: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }
  void cancelResendTimer() {

    _timer = null;
  }
  void _startNewCycle() {
    startResendTimer();
  }
}
