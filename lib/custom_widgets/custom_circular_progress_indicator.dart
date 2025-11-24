// lib/widgets/custom_circular_progress_indicator.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/styles/colors.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double size;

  const CustomCircularProgressIndicator({
    super.key,
    this.color = kPrimaryColor,
    this.strokeWidth = 2.0,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color,
        backgroundColor: kTransparentColor,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
