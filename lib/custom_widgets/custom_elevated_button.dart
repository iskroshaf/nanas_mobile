// lib/widgets/custom_elevated_button.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:nanas_mobile/custom_widgets/custom_circular_progress_indicator.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  // New: Icon support
  final IconData? icon;
  final double iconSize;

  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double elevation;
  final Color foregroundColor;
  final bool isDisable;
  final bool isLoading;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconSize = kIconSizeSmall,
    this.padding = kPaddingButton,
    this.borderRadius = kBorderRadiusFull,
    this.backgroundColor = kPrimaryColor,
    this.elevation = 0.0,
    this.borderColor = kTransparentColor,
    this.borderWidth = 0.0,
    this.foregroundColor = kWhiteColor,
    this.isDisable = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return IgnorePointer(
      ignoring: isDisable || isLoading,
      child: Opacity(
        opacity: isDisable || isLoading ? 0.5 : 1.0,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: padding,
            elevation: elevation,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            side: BorderSide(color: borderColor, width: borderWidth),
          ),
          child:
              isLoading
                  ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CustomCircularProgressIndicator(
                      color: foregroundColor,
                      strokeWidth: 2.5,
                    ),
                  )
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: iconSize, color: foregroundColor),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: textTheme.titleMedium?.copyWith(
                          color: foregroundColor,
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
