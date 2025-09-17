// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:googleapis_auth/auth_io.dart';
//
// import '../core/image/image_utils.dart';
// Future<void> sendFCMNotification({
//
//
//    required Map<String, Map<String, dynamic>> bodyMap
// }) async {
//   // Step 1: Load service account credentials
//   final serviceAccountJson = await rootBundle.loadString(jsonFile);
//   final credentials = ServiceAccountCredentials.fromJson(serviceAccountJson);
//
//   // Step 2: Define the required scope
//   final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
//
//   // Step 3: Authenticate and get access token
//   final client = await clientViaServiceAccount(credentials, scopes);
//
//
//   final fcmUrl = 'https://fcm.googleapis.com/v1/projects/yoga-buddy-266417/messages:send';
//
//
//   // Step 5: Send request
//   final response = await client.post(
//     Uri.parse(fcmUrl),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode(bodyMap),
//   );
//
//   if (response.statusCode == 200) {
//     debugPrint("✅ Notification sent: ${response.body}");
//   } else {
//     debugPrint("❌ Failed to send: ${response.statusCode}\n${response.body}");
//   }
//
//   client.close(); // Clean up
// }
//
