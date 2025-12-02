// lib/widgets/custom_outlined_button.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:nanas_mobile/custom_widgets/custom_circular_progress_indicator.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  // New: Icon support
  final IconData? icon;
  final double iconSize;

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
    this.icon,
    this.iconSize = kIconSizeSmall,
    this.padding = kPaddingButton,
    this.borderRadius = kBorderRadiusFull,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.isDisable = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color effectiveForegroundColor =
        foregroundColor ?? (isDark ? kWhiteColor : kTextColorMedium);

    final Color effectiveBorderColor = borderColor ?? effectiveForegroundColor;

    final Color effectiveBackgroundColor =
        backgroundColor ?? Colors.transparent;

    return IgnorePointer(
      ignoring: isDisable || isLoading,
      child: Opacity(
        opacity: isDisable || isLoading ? 0.5 : 1.0,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            foregroundColor: effectiveForegroundColor,
            backgroundColor: effectiveBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            side: BorderSide(color: effectiveBorderColor, width: borderWidth),
          ),
          child:
              isLoading
                  ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CustomCircularProgressIndicator(
                      color: effectiveForegroundColor,
                      strokeWidth: 2.5,
                    ),
                  )
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: iconSize,
                          color: effectiveForegroundColor,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: effectiveForegroundColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
