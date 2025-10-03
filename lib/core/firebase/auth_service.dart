import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:neeknots/core/hive/app_config_cache.dart';

import '../../main.dart';
import '../../routes/app_routes.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>> signupUser({
    required String email,
    required String storeName,
    required String websiteUrl,
    required String mobile,
    required String logoUrl,
    required String name,
     String? countryCode,
    File? photo,
  }) async {
    try {
      // Check if email or mobile already exists
      final existing = await _firestore
          .collection("stores")
          .where("email", isEqualTo: email)
          .get();
      if (existing.docs.isNotEmpty) {
        throw "Email already exists";
      }

      // Auto-generate document ID
      final docRef = _firestore.collection("stores").doc();
      String uid = docRef.id;

      // Upload photo if exists
      String photoUrl = "";
      if (photo != null) {
        final ref = _storage.ref().child("store_photos").child("$uid.jpg");
        await ref.putFile(photo);
        photoUrl = await ref.getDownloadURL();
      }

      // Get FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      // Save user data
      Map<String, dynamic> userData = {
        "store_name": storeName,
        "website_url": websiteUrl,
        "email": email,
        "mobile": mobile,
        "name": name,
        "accessToken": '',
        "version_code": '',
        "logo_url": logoUrl,
        "photo": photoUrl,
        "country_code": countryCode??"+1",
        "fcm_token": fcmToken ?? "",
        "active_status": false,
        "created_at": FieldValue.serverTimestamp(),
      };

      await docRef.set(userData);
      userData["uid"] = uid; // return uid
      return userData;
    } catch (e) {
      throw Exception("Signup failed: $e");
    }
  }

  /// 🔹 Login User with Email + Mobile
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String mobile,
    required String countryCode,
  }) async {
    try {
      // Check Firestore for a document matching BOTH email and mobile
      final query = await _firestore
          .collection("stores")
          .where("email", isEqualTo: email)
          .where("mobile", isEqualTo: mobile)
          .where("country_code", isEqualTo: countryCode)
          .get();
      if (query.docs.isEmpty) {
        throw "User not found with this email and mobile number";
      }

      final data = query.docs.first.data();

      if (data["active_status"] != true) {
        throw "Your account is inactive. Contact admin.";
      }

      data["uid"] = query.docs.first.id; // add UID
      return data;
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  /// 🔹 Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>> checkUserStatus({
    required String emailOrMobile,
  }) async {
    try {
      // 1️⃣ Check by email
      final query = await _firestore
          .collection("stores")
          .where("email", isEqualTo: emailOrMobile)
          .get();

      List<QueryDocumentSnapshot> docs = query.docs;

      // 2️⃣ If email not found, check by mobile
      if (docs.isEmpty) {
        final mobileQuery = await _firestore
            .collection("stores")
            .where("mobile", isEqualTo: emailOrMobile)
            .get();

        if (mobileQuery.docs.isEmpty) {
          throw "Unauthorized: User not found";
        }

        docs = mobileQuery.docs;
      }

      // 3️⃣ Get first user document
      final data = docs.first.data() as Map<String, dynamic>;

      // 4️⃣ Check active_status
      if (data["active_status"] != true) {
        throw "Unauthorized: Account inactive";
      }

      // 5️⃣ Add UID
      data["uid"] = docs.first.id;

      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Delete user from Firestore (and optionally Firebase Auth)
  Future<void> deleteUser({required String uid}) async {
    try {
      await _firestore.collection("stores").doc(uid).delete();
      print("User deleted successfully ✅");
    } catch (e) {
      print("Error deleting user: $e");
      rethrow;
    }
  }

  // Example usage in a button or any widget
  Future<void> deleteCurrentUser({
    required BuildContext context,
    required String uid,
  }) async {
    final authService = AuthService();

    try {
      await authService.deleteUser(uid: uid);

      // 1️⃣ Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Your account has been deleted successfully."),
          backgroundColor: Colors.green,
        ),
      );

      // 2️⃣ Wait a short moment to show the message
      await Future.delayed(Duration(seconds: 2));

      await AppConfigCache.clearConfig();
      // 3️⃣ Redirect to login screen
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        RouteName.loginScreen,
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete account: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String userID,
    required String enteredOtp,
  }) async {
    try {
      // 1️⃣ Get the user document from Firestore
      final docRef = _firestore.collection("stores").doc(userID);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw "User not found";
      }

      final data = docSnapshot.data() as Map<String, dynamic>;

      // 2️⃣ Check if OTP exists
      if (!data.containsKey("otp")) {
        throw "OTP not found. Please request a new OTP.";
      }

      final storedOtp = data["otp"];
      final Timestamp otpCreatedAt = data["otp_created_at"];

      // 3️⃣ Optional: check OTP expiry (e.g., 15 minutes)
      final currentTime = DateTime.now();
      final otpTime = otpCreatedAt.toDate();
      if (currentTime.difference(otpTime).inMinutes > 15) {
        throw "OTP expired. Please request a new OTP.";
      }

      // 4️⃣ Verify OTP
      if (storedOtp == enteredOtp) {
        // OTP is correct, mark user as active
        await docRef.update({
          "active_status": true,
          "otp": FieldValue.delete(),
          "otp_created_at": FieldValue.delete(),
        });

        // 5️⃣ Return user details
        final updatedDoc = await docRef.get();
        final userData = updatedDoc.data() as Map<String, dynamic>;
        userData["uid"] = updatedDoc.id; // Include UID
        return userData;
      } else {
        throw "Invalid OTP. Please try again.";
      }
    } catch (e) {
      throw Exception("OTP verification failed: $e");
    }
  }
  Future<void> updateFcm({
    required String userID,
    required String fcmToken,
  }) async {
    try {
      // 1️⃣ Get the user document from Firestore
      final docRef = _firestore.collection("stores").doc(userID);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw "User not found";
      }

      await docRef.update({
        "fcm_token": fcmToken,

      });

    } catch (e) {
      throw Exception("OTP verification failed: $e");
    }
  }
  /// 🔹 Get all users from Firestore
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection("stores").get();

      if (querySnapshot.docs.isEmpty) {
        return []; // No users found
      }

      // Map each document to a Map<String, dynamic> including its UID
      final users = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data["uid"] = doc.id; // Add UID
        return data;
      }).toList();

      return users;
    } catch (e) {
      throw Exception("Failed to fetch users: $e");
    }
  }


  Future<void> insetContactUSForm({
    required String email,

    required String message,
    required String mobile,
    required String name,

  }) async {
    try {

      final docRef = _firestore.collection("contact_us").doc();
      String uid = docRef.id;


      // Get FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      // Save user data
      Map<String, dynamic> userData = {

        "uid": uid,
        "email": email,
        "mobile": mobile,
        "name": name,
        "message": message,
        "isSeen": false  , // 👈 ye flag add karna hoga
        "fcm_token": fcmToken ?? "",
        "created_at": FieldValue.serverTimestamp(),
      };
      await docRef.set(userData);
    /*  userData["uid"] = uid; // return uid
      return userData;*/
    } catch (e) {
      throw Exception("Signup failed: $e");
    }
  }


}
