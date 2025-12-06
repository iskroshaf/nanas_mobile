// lib/screens/profile_settings.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

import 'package:nanas_mobile/custom_widgets/custom_app_bar.dart';
import 'package:nanas_mobile/custom_widgets/custom_circular_progress_indicator.dart';
import 'package:nanas_mobile/custom_widgets/custom_snack_bar.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';
import 'package:nanas_mobile/helpers/image_picker.dart';
import 'package:nanas_mobile/services/ent.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';

final String? _domain = dotenv.env['DOMAIN'];
final String? _port = dotenv.env['PORT'];

String buildImageUrl(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return path;
  }
  if (_domain == null || _domain!.isEmpty) return path;
  if (_port == null || _port!.isEmpty) {
    return '$_domain$path';
  }
  return '$_domain:$_port$path';
}

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool _isValid = false;
  bool _isUpdate = false;
  bool _isLoadingProfile = false;

  final _fullNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _icCtrl = TextEditingController();

  XFile? _ownerImage;
  String? _existingProfilePhoto; 

  @override
  void initState() {
    super.initState();
    _loadProfile();

    _fullNameCtrl.addListener(_validate);
    _phoneCtrl.addListener(_validate);
    _icCtrl.addListener(_validate);
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _icCtrl.dispose();
    super.dispose();
  }

  void _validate() {
    setState(() {
      _isValid =
          _fullNameCtrl.text.isNotEmpty &&
          _phoneCtrl.text.isNotEmpty &&
          _icCtrl.text.isNotEmpty;
    });
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoadingProfile = true;
    });

    try {
      final p = await EntService.getProfile();

      _fullNameCtrl.text = p["full_name"]?.toString() ?? "";
      _usernameCtrl.text = p["username"]?.toString() ?? "";
      _emailCtrl.text = p["email"]?.toString() ?? "";
      _phoneCtrl.text = p["phone_no"]?.toString() ?? "";
      _icCtrl.text = p["ic"]?.toString() ?? "";
      _existingProfilePhoto = p["profile_photo"]?.toString();

      setState(() {});
    } catch (e) {
      CustomSnackBar.show(
        // ignore: use_build_context_synchronously
        context: context,
        message: "Failed to load profile",
        type: SnackBarType.error,
      );
    } finally {
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final img = await ImagePickerHelper.pickImage(context);

    if (img != null) {
      if (img is XFile) {
        setState(() {
          _ownerImage = img as XFile?;
        });
      } else {
        setState(() {
          _ownerImage = XFile(img.path);
        });
      }
    } else {
    }
  }

  Future<void> _update() async {
    if (_isUpdate) return;
    if (!_isValid) return;

    setState(() => _isUpdate = true);

    try {
      File? imageFile;
      if (_ownerImage != null) {
        imageFile = File(_ownerImage!.path);
      } else {
      }

      final response = await EntService.updateProfile(
        fullName: _fullNameCtrl.text,
        phoneNo: _phoneCtrl.text,
        ic: _icCtrl.text,
        imageFile: imageFile,
      );

      final newPhoto = response["profile_photo"]?.toString();

      CustomSnackBar.show(
        // ignore: use_build_context_synchronously
        context: context,
        message: "Profile updated successfully",
        type: SnackBarType.success,
      );

      if (newPhoto != null && newPhoto.isNotEmpty) {
        setState(() {
          _existingProfilePhoto = newPhoto;
          _ownerImage = null; 
        });
      } else {
        setState(() {});
      }
    } catch (e) {
      CustomSnackBar.show(
        // ignore: use_build_context_synchronously
        context: context,
        message: "Failed to update profile",
        type: SnackBarType.error,
      );
    } finally {
      setState(() => _isUpdate = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        text: "Profile Settings",
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        titleColor: kWhiteColor,
        leadingIconColor: kWhiteColor,
        isLeadingDisabled: _isUpdate,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child:
                  _isUpdate
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CustomCircularProgressIndicator(
                          color: kSecondaryColor,
                        ),
                      )
                      : Opacity(
                        opacity: _isValid ? 1 : 0.5,
                        child: GestureDetector(
                          onTap: _isValid ? _update : null,
                          child: Text(
                            "Save",
                            style: textTheme.bodyMedium!.copyWith(
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
        child:
            _isLoadingProfile
                ? const Center(child: CustomCircularProgressIndicator())
                : SingleChildScrollView(
                  padding: kPaddingBody,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: _isUpdate ? null : _pickImage,
                        child: ClipOval(
                          child: Container(
                            width: 150,
                            height: 150,
                            color: Colors.grey.shade200,
                            child: _buildProfileImage(textTheme),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      _field("Full Name", _fullNameCtrl, false),
                      const SizedBox(height: 12),
                      _field("Username", _usernameCtrl, true),
                      const SizedBox(height: 12),
                      _field("Email", _emailCtrl, true),
                      const SizedBox(height: 12),
                      _field("Phone Number", _phoneCtrl, false),
                      const SizedBox(height: 12),
                      _field("IC / Passport", _icCtrl, false),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildProfileImage(TextTheme textTheme) {
    if (_ownerImage != null) {
      return Image.file(File(_ownerImage!.path), fit: BoxFit.cover);
    }

    if (_existingProfilePhoto != null && _existingProfilePhoto!.isNotEmpty) {
      final url = buildImageUrl(_existingProfilePhoto!);
      return Image.network(url, fit: BoxFit.cover);
    }

    return _placeholder(textTheme);
  }

  Widget _placeholder(TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FontAwesomeIcons.image, size: 32, color: Colors.grey),
          const SizedBox(height: 8),
          Text("Tap to upload image", style: textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, bool disabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        CustomTextField(
          controller: ctrl,
          isDisable: disabled || _isUpdate,
          hintText: label,
        ),
      ],
    );
  }
}
