import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/core/component/component.dart';
import 'package:neeknots/core/image/image_utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return commonScaffold(
      body: commonAppBackground(
        child: SafeArea(
          child: ListView(
            children: [
          
              SizedBox(height: size.height*0.1,),
              commonSvgWidget(
                color: colorLogo,
                path: icLogo,
                width: size.width * 0.6,
              ),
            ],
          ),
        ),
      ),
    );

  }
}
