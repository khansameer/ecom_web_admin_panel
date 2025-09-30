import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../core/firebase/auth_service.dart';
import '../core/string/string_utils.dart';

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
  TextEditingController tetPhone = TextEditingController();
  TextEditingController tetCountryCodeController = TextEditingController(text: "+1");

  final tetStoreName = TextEditingController();
  final tetWebsiteUrl = TextEditingController();
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
    tetFullName.clear();
    tetEmail.clear();
    tetPhone.clear();
    tetStoreName.clear();
    tetWebsiteUrl.clear();
    tetPassword.clear();
    tetCurrentPassword.clear();
    tetNewPassword.clear();
    tetConfirmPassword.clear();
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
  final AuthService _authService = AuthService();

  String generateOtp() {
    return (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String mobile,
  }) async {
    _setLoading(true);
    try {
      _userData = await _authService.loginUser(email: email, mobile: mobile);

      notifyListeners();
      if (_userData?.isNotEmpty == true) {
        String otp = generateOtp();

        await sendOtpEmail(email: email, userID: userData?['uid'], otp: otp);
      }

      return _userData ?? {}; // 🔹 return the user data
    } catch (e) {
      _setLoading(false);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendOtpEmail({
    required String email,
    required String otp,
    required String userID,
  }) async {
    _setLoading(true);
    print('=====eail;#$email');

    if (email.isEmpty) {
      print('Recipient email is empty!');
      return; // stop execution
    }

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': otpServiceID,
        'template_id': otpTemplateID,
        'user_id': otpPublicID,
        'template_params': {
          'email': email,
          'passcode': otp,
          'time': '15 minutes', // or generate expiry dynamically
        },
      }),
    );

    if (response.statusCode == 200) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      print('OTP sent successfully!');
      await _firestore.collection("stores").doc(userID).update({
        "otp": otp,
        "otp_created_at": FieldValue.serverTimestamp(),
        "active_status": false, // Ensure user is inactive until OTP verified
      });

      _setLoading(false);
    } else {
      _setLoading(false);
      print('Failed to send OTP: ${response.body}');
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
    tetConfirmPassword.clear();

    notifyListeners();
  }
}
