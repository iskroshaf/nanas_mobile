// lib/screens/add_announcement.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_app_bar.dart';
import 'package:nanas_mobile/custom_widgets/custom_elevated_button.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';
import 'package:nanas_mobile/helpers/image_picker.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
// import 'dart:developer' as developer;

class AddAnnouncement extends StatefulWidget {
  const AddAnnouncement({super.key});

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  File? _announcementImage;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        text: 'Add Announcement',
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        titleColor: kWhiteColor,
        leadingIconColor: kWhiteColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: kPaddingBody.copyWith(top: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share important updates with your team and stakeholders.',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () async {
                        final picked = await ImagePickerHelper.pickImage(
                          context,
                        );
                        if (picked != null) {
                          setState(() => _announcementImage = picked);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: kBorderRadiusSmall,
                          border: Border.all(color: const Color(0xFFf3f4f6)),
                        ),
                        child:
                            _announcementImage != null
                                ? Image.file(
                                  _announcementImage!,
                                  fit: BoxFit.cover,
                                )
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
                    const SizedBox(height: 24),
                    buildAnnouncementField(
                      context,
                      'Title',
                      false,
                      false,
                      'Enter announcement title',
                      _titleCtrl,
                    ),
                    const SizedBox(height: 12),
                    buildAnnouncementField(
                      context,
                      'Description',
                      false,
                      false,
                      'Provide details about the announcement',
                      _descriptionCtrl,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              width: double.infinity,
              child: CustomElevatedButton(text: 'Publish', onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildAnnouncementField(
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
