// lib/widgets/custom_text_button.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:nanas_mobile/custom_widgets/custom_circular_progress_indicator.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color? foregroundColor;
  final bool isDisable;
  final bool isLoading;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.padding = kPaddingMedium,
    this.borderRadius = kBorderRadiusFull,
    this.foregroundColor,
    this.isDisable = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color effectiveColor =
        foregroundColor ?? (isDark ? kWhiteColor : kTextColorMedium);

    return IgnorePointer(
      ignoring: isDisable || isLoading,
      child: Opacity(
        opacity: isDisable || isLoading ? 0.5 : 1,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: padding,
            foregroundColor: effectiveColor,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            textStyle: const TextStyle(
              fontFamily: 'myFont',
              fontWeight: FontWeight.normal,
              fontSize: kFontSizeMedium,
            ),
          ),
          child:
              isLoading
                  ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CustomCircularProgressIndicator(
                      color: effectiveColor,
                      strokeWidth: 2.0,
                    ),
                  )
                  : Text(text),
        ),
      ),
    );
  }
}
