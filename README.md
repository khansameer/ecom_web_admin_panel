# neeknots

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



ElevatedButton(
onPressed: () async {
// Check Firestore for email+mobile
final authService = FirestoreAuthService();
final user = await authService.loginUser(
email: _emailController.text.trim(),
mobile: _mobileController.text.trim(),
);

    if (user != null) {
      // Send OTP
      final otpService = OtpService();
      await otpService.sendEmailOtp(user["email"]);
      await otpService.sendMobileOtp(user["mobile"]);

      // Navigate to OTP verification screen
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(userData: user)
      ));
    }
},
child: const Text("Send OTP"),
)


flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d web-server


flutter run -d chrome --no-wasm-dry-run