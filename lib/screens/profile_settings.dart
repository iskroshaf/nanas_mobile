// lib/screens/profile_settings.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_app_bar.dart';
import 'package:nanas_mobile/custom_widgets/custom_circular_progress_indicator.dart';
import 'package:nanas_mobile/custom_widgets/custom_snack_bar.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';
import 'package:nanas_mobile/helpers/image_picker.dart';
import 'package:nanas_mobile/services/ent.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'dart:developer' as developer;
import 'dart:io';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool _isValidFields = false;
  bool _isUpdate = false;

  final _fullNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController(text: 'iskroshaf@gmail.com');
  final _phoneNumberCtrl = TextEditingController();
  final _icCtrl = TextEditingController();

  File? _ownerImage;

  @override
  void initState() {
    super.initState();

    _fullNameCtrl.addListener(_validateFields);
    _usernameCtrl.addListener(_validateFields);
    _phoneNumberCtrl.addListener(_validateFields);
    _icCtrl.addListener(_validateFields);

    _validateFields();
  }

  void _validateFields() {
    setState(() {
      _isValidFields =
          _fullNameCtrl.text.trim().isNotEmpty &&
          _usernameCtrl.text.trim().isNotEmpty &&
          _phoneNumberCtrl.text.trim().isNotEmpty &&
          _icCtrl.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _fullNameCtrl.removeListener(_validateFields);
    _usernameCtrl.removeListener(_validateFields);
    _phoneNumberCtrl.removeListener(_validateFields);
    _icCtrl.removeListener(_validateFields);

    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneNumberCtrl.dispose();
    _icCtrl.dispose();
    super.dispose();
  }

  Future<void> _updateUserProfile() async {
    if (_isUpdate) return;

    setState(() {
      _isUpdate = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      await EntService.updateProfile(fullname: _fullNameCtrl.text);

      if (context.mounted) {
        if (!mounted) return;
        CustomSnackBar.show(
          context: context,
          message: "Profile updated successfully",
          type: SnackBarType.success,
        );
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      if (!mounted) return;
      if (context.mounted) {
        CustomSnackBar.show(
          context: context,
          message: "Failed to update profile",
          type: SnackBarType.error,
        );
      }
    } finally {
      if (context.mounted) {
        setState(() {
          _isUpdate = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        text: 'Profile Settings',
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        titleColor: kWhiteColor,
        leadingIconColor: kWhiteColor,
        isLeadingDisabled: _isUpdate,
        actions: [
          Container(
            width: 50,
            padding: EdgeInsets.only(right: 20.0),
            child: Center(
              child:
                  _isUpdate
                      ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CustomCircularProgressIndicator(
                          color: kSecondaryColor,
                        ),
                      )
                      : Opacity(
                        opacity: _isValidFields ? 1 : 0.5,
                        child: GestureDetector(
                          onTap:
                              _isValidFields
                                  ? () {
                                    _updateUserProfile();
                                  }
                                  : null,
                          child: Text(
                            'Save',
                            style: textTheme.bodyMedium?.copyWith(
                              color: kSecondaryColor,
                            ),
                          ),
                        ),
                      ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: kPaddingBody.copyWith(top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us a little about yourself as the farm owner.',
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await ImagePickerHelper.pickImage(context);
                    if (picked != null) {
                      setState(() => _ownerImage = picked);
                    }
                  },
                  child: ClipOval(
                    child: Container(
                      width: 150,
                      height: 150,
                      color: kWhiteColor,
                      child:
                          _ownerImage != null
                              ? Image.file(_ownerImage!, fit: BoxFit.cover)
                              : Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.image,
                                      size: kIconSizeLarge,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tap to upload image',
                                      style: textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              buildProfileSettingField(
                context,
                'Full Name',
                false,
                _isUpdate,
                'Enter your full name',
                _fullNameCtrl,
              ),
              const SizedBox(height: 12),
              buildProfileSettingField(
                context,
                'Username',
                false,
                _isUpdate,
                'Enter your username',
                _usernameCtrl,
              ),
              const SizedBox(height: 12),
              buildProfileSettingField(
                context,
                'Email',
                false,
                true,
                'Your email address',
                _emailCtrl,
              ),
              const SizedBox(height: 12),
              buildProfileSettingField(
                context,
                'Phone Number',
                true,
                _isUpdate,
                'e.g. 0123456789',
                _phoneNumberCtrl,
              ),
              const SizedBox(height: 12),
              buildProfileSettingField(
                context,
                'IC / Passport Number',
                true,
                _isUpdate,
                'e.g. 901234567890',
                _icCtrl,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildProfileSettingField(
  BuildContext context,
  String label,
  bool isNumber,
  bool isDisable,
  String hintText,
  TextEditingController controller,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      SizedBox(height: 4),
      CustomTextField(
        controller: controller,
        isDisable: isDisable,
        hintText: hintText,
      ),
    ],
  );
}
