import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(222, 239, 227, 1),
              Color.fromRGBO(168, 223, 245, 1),
              Color.fromRGBO(203, 168, 255, 1), // bottom
            ],
          ),
        ),
        child: Center(
          child: Container(
            height: 200,
            width: 200,
            color: Colors.white,
            child: Text("Splash Page"),
          ),
        ),
      ),
    );
  }
}
