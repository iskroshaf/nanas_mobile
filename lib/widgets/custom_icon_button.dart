// lib/widgets/custom_icon_button.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';

class CustomIconButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double iconSize;
  final Color? iconColor;

  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize = kIconSizeSmall,
    this.iconColor,
  });

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isTapped = true),
      onTapUp: (_) {
        setState(() => _isTapped = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isTapped = false),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: _isTapped ? 0.5 : 1.0,
        child: Icon(
          widget.icon,
          size: widget.iconSize,
          color: widget.iconColor ?? (isDark ? kWhiteColor : kIconColor),
        ),
      ),
    );
  }
}
