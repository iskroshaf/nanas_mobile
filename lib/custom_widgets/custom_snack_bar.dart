// lib/widgets/custom_snack_bar.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';

enum SnackBarType { success, error, warning, info }

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color getBackgroundColor(SnackBarType type) {
      switch (type) {
        case SnackBarType.success:
          return kSuccessColor;
        case SnackBarType.error:
          return kErrorColor;
        case SnackBarType.warning:
          return kWarningColor;
        case SnackBarType.info:
          return kInfoColor;
      }
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.clearSnackBars();

    final snackBarContent = Container(
      margin: const EdgeInsets.all(0),
      child: Material(
        elevation: 0,
        borderRadius: kBorderRadiusMedium,
        color: getBackgroundColor(type),
        child: Padding(
          padding: kPaddingSnackBar,
          child: Text(
            message,
            style: const TextStyle(
              fontFamily: 'myFont',
              fontSize: kFontSizeMedium,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    final snackBarWidget = _AnimatedSnackBar(
      duration: duration,
      child: snackBarContent,
    );

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: snackBarWidget,
        backgroundColor: kTransparentColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        elevation: 0,
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _AnimatedSnackBar extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const _AnimatedSnackBar({required this.child, required this.duration});

  @override
  State<_AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<_AnimatedSnackBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _animation, child: widget.child);
  }
}
