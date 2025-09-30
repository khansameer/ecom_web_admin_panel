import 'package:flutter/material.dart';
import 'package:neeknots/core/color/color_utils.dart';
import 'package:neeknots/provider/admin_dashboard_provider.dart';
import 'package:provider/provider.dart';

import '../core/component/component.dart';
import '../core/firebase/send_fcm_notification.dart';
import '../core/image/image_utils.dart';
import '../core/validation/validation.dart';

class CommonAdminWidget extends StatefulWidget {
  const CommonAdminWidget({
    super.key,
    required this.data,
    required this.provider,
    required this.onPressed,
  });

  final Map<String, dynamic> data;
  final AdminDashboardProvider provider;
  final VoidCallback onPressed;

  @override
  State<CommonAdminWidget> createState() => _State();
}

class _State extends State<CommonAdminWidget> {
  @override
  void initState() {
    super.initState();
    widget.provider.tetFullName.text = widget.data["name"];
    widget.provider.tetEmail.text = widget.data["email"];
    widget.provider.tetPhone.text = widget.data["mobile"];
    widget.provider.tetStoreName.text = widget.data["store_name"];
    widget.provider.tetAccessToken.text = widget.data["accessToken"];
    widget.provider.tetVersionCode.text = widget.data["version_code"];
    widget.provider.tetAppLogo.text = widget.data["logo_url"] ?? '';
    widget.provider.tetWebsiteUrl.text = widget.data["website_url"];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.provider.setStatus(widget.data["active_status"] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        commonTextField(
          keyboardType: TextInputType.name,
          prefixIcon: commonPrefixIcon(image: icUser),
          controller: widget.provider.tetFullName,
          hintText: "Full Name",
        ),
        const SizedBox(height: 20),

        commonTextField(
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
          readOnly: true,
          fillColor: Colors.grey.withValues(alpha: 0.1),
          filled: true,

          prefixIcon: commonPrefixIcon(image: icEmail),
          controller: widget.provider.tetEmail,
          hintText: "Email Address",
        ),

        const SizedBox(height: 20),
        commonTextField(
          hintText: "Phone No",
          controller: widget.provider.tetPhone,
          readOnly: true,
          maxLines: 1,
          fillColor: Colors.grey.withValues(alpha: 0.1),
          filled: true,

          keyboardType: TextInputType.phone,
          validator: validateTenDigitPhone,
          prefixIcon: commonPrefixIcon(image: icPhone),
        ),
        const SizedBox(height: 20),
        commonTextField(
          hintText: "Store Name",
          controller: widget.provider.tetStoreName,

          maxLines: 1,

          keyboardType: TextInputType.text,

          prefixIcon: commonPrefixIcon(image: icStore),
        ),
        const SizedBox(height: 20),
        commonTextField(
          hintText: "Access Token",
          controller: widget.provider.tetAccessToken,

          maxLines: 1,

          keyboardType: TextInputType.text,

          prefixIcon: commonPrefixIcon(image: icStore),
        ),

        const SizedBox(height: 20),
        commonTextField(
          hintText: "App Version Code",
          controller: widget.provider.tetVersionCode,

          maxLines: 1,

          keyboardType: TextInputType.text,

          prefixIcon: commonPrefixIcon(image: icStore),
        ),
        const SizedBox(height: 20),
        commonTextField(
          hintText: "App Logo Url",
          controller: widget.provider.tetAppLogo,

          maxLines: 1,

          keyboardType: TextInputType.text,

          prefixIcon: commonPrefixIcon(image: icStore),
        ),
        const SizedBox(height: 20),
        commonTextField(
          hintText: "Website Url",
          controller: widget.provider.tetWebsiteUrl,

          maxLines: 1,

          keyboardType: TextInputType.url,

          prefixIcon: commonPrefixIcon(image: icNetwork),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            commonText(text: "Status"),
            Consumer<AdminDashboardProvider>(
              builder: (context, provider, child) {
                return Switch(
                  inactiveThumbColor: colorLogo,
                  activeTrackColor: colorLogo,
                  value: provider.status,
                  onChanged: (val) {
                    provider.setStatus(val);
                  },
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 20),
        commonButton(
          text: "Update",
          onPressed: () async {
            print('======${widget.data["uid"]}');
            await widget.provider.updateUser(docId: widget.data["uid"],token: widget.data['fcm_token']);


            Navigator.pop(context);
            //widget.provider.updateUser( widget.data["uid"]);
          },
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
