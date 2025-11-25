// lib/widgets/custom_outlined_button.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:nanas_mobile/custom_widgets/custom_circular_progress_indicator.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final bool isDisable;
  final bool isLoading;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.padding = kPaddingButton,
    this.borderRadius = kBorderRadiusFull,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor = kLineLightColor,
    this.borderWidth = 1.0,
    this.isDisable = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color effectiveForegroundColor =
        foregroundColor ?? (isDark ? kWhiteColor : kTextColorMedium);
    final Color effectiveBackgroundColor =
        backgroundColor ?? (isDark ? kWhiteColor : Color(0xfff3f4f6));
    final Color effectiveBorderColor = borderColor ?? effectiveForegroundColor;

    return IgnorePointer(
      ignoring: isDisable || isLoading,
      child: Opacity(
        opacity: isDisable || isLoading ? 0.5 : 1,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            foregroundColor: effectiveForegroundColor,
            backgroundColor: effectiveBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            side: BorderSide(color: effectiveBorderColor, width: borderWidth),
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
                      color: effectiveForegroundColor,
                      strokeWidth: 2.0,
                    ),
                  )
                  : Text(text),
        ),
      ),
    );
  }
}
