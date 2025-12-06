// lib/helpers/image_picker.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage(BuildContext context) async {
    final textTheme = Theme.of(context).textTheme;

    final File? selectedFile = await showModalBottomSheet<File?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(sheetContext).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            child: Padding(
              padding: kPaddingBody.copyWith(top: 16, bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Choose Image Source', style: textTheme.titleLarge),
                  const SizedBox(height: 16),

                  // CAMERA
                  _buildOptionCard(
                    context: sheetContext,
                    theme: Theme.of(sheetContext),
                    icon: FontAwesomeIcons.camera,
                    title: 'Camera',
                    subtitle: 'Take a new photo',
                    onTap: () async {
                      final file = await _pickImageFromSource(
                        ImageSource.camera,
                        sheetContext,
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pop(sheetContext, file);
                    },
                  ),
                  const SizedBox(height: 8),

                  // GALLERY
                  _buildOptionCard(
                    context: sheetContext,
                    theme: Theme.of(sheetContext),
                    icon: FontAwesomeIcons.images,
                    title: 'Gallery',
                    subtitle: 'Choose from your photos',
                    onTap: () async {
                      final file = await _pickImageFromSource(
                        ImageSource.gallery,
                        sheetContext,
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pop(sheetContext, file);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Di sini, selectedFile ialah nilai yang dihantar melalui Navigator.pop(ctx, file)
    return selectedFile;
  }

  static Widget _buildOptionCard({
    required BuildContext context,
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(icon, color: kPrimaryColor, size: kIconSizeSmall),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          FaIcon(
            FontAwesomeIcons.chevronRight,
            size: kIconSizeSmall,
            color: kIconColor,
          ),
        ],
      ),
    );
  }

  static Future<File?> _pickImageFromSource(
    ImageSource source,
    BuildContext context,
  ) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
    return null;
  }
}
