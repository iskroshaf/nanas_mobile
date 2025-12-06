// lib/helpers/image_viewer.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_icon_button.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';

class ImageViewerHelper {
  static void viewImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: kBorderRadiusMedium,
                child: Image.network(imagePath, fit: BoxFit.contain),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomIconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: FontAwesomeIcons.xmark,
                  iconColor: kWhiteColor,
                  iconSize: kIconSizeMedium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
