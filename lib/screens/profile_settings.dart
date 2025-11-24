// lib/screens/profile_settings.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/custom_widgets/custom_app_bar.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: 'Profile Settings',
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        titleColor: kWhiteColor,
        leadingIconColor: kWhiteColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: kPaddingBody.copyWith(top: 16, bottom: 16),
          child: Column(
            children: [
              buildProfileSettingItem(
                context,
                'Username',
                TextEditingController(),
              ),
              SizedBox(height: 8),
              buildProfileSettingItem(
                context,
                'Email',
                TextEditingController(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildProfileSettingItem(
  BuildContext context,
  String label,
  TextEditingController controller,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      SizedBox(height: 4),
      CustomTextField(controller: controller),
    ],
  );
}
