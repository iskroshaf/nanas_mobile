// lib/screens/add_announcement.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_app_bar.dart';
import 'package:nanas_mobile/custom_widgets/custom_elevated_button.dart';
import 'package:nanas_mobile/custom_widgets/custom_snack_bar.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';
import 'package:nanas_mobile/helpers/image_picker.dart';
import 'package:nanas_mobile/providers/announcement.dart';
import 'package:nanas_mobile/services/announcement.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';

class AddAnnouncement extends ConsumerStatefulWidget {
  const AddAnnouncement({super.key});

  @override
  ConsumerState<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends ConsumerState<AddAnnouncement> {
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  File? _announcementImage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    final desc = _descriptionCtrl.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and description are required')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await AnnouncementService.createAnnouncement(
        title: title,
        description: desc,
        imageFile: _announcementImage,
      );

      ref.invalidate(myAnnouncementProvider);
      ref.invalidate(announcementProvider);

      CustomSnackBar.show(
        // ignore: use_build_context_synchronously
        context: context,
        message: 'Announcement Added Successfully',
        type: SnackBarType.success,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to publish announcement: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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

                    // IMAGE PICKER
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
                      'Enter announcement title',
                      _titleCtrl,
                    ),
                    const SizedBox(height: 12),
                    buildAnnouncementField(
                      context,
                      'Description',
                      'Provide details about the announcement',
                      _descriptionCtrl,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              width: double.infinity,
              child: CustomElevatedButton(
                text: _isSubmitting ? 'Publishing...' : 'Publish',
                onPressed: _isSubmitting ? null : _submit,
              ),
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
  String hintText,
  TextEditingController controller, {
  int maxLines = 1,
}) {
  final textTheme = Theme.of(context).textTheme;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: textTheme.bodyMedium),
      const SizedBox(height: 4),
      CustomTextField(
        controller: controller,
        hintText: hintText,
        maxLines: maxLines,
      ),
    ],
  );
}
