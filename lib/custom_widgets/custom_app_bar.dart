// lib/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/custom_widgets/custom_icon_button.dart';
import 'package:nanas_mobile/styles/sizes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final List<Widget>? actions;
  final VoidCallback? onPressed;
  final bool showLeadingIcon;
  final bool isLeadingDisabled;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;
  final Gradient? gradient;
  final double titleFontSize;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? leadingIconColor;

  const CustomAppBar({
    super.key,
    required this.text,
    this.actions,
    this.onPressed,
    this.centerTitle = false,
    this.showLeadingIcon = true,
    this.isLeadingDisabled = false,
    this.bottom,
    this.gradient,
    this.titleFontSize = kFontSizeLarge,
    this.leading,
    this.leadingIconColor,
    this.backgroundColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      title: Text(
        text,
        style: textTheme.titleLarge?.copyWith(
          fontSize: titleFontSize,
          color: titleColor,
        ),
      ),
      centerTitle: centerTitle,

      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,

      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,

      leading:
          leading ??
          (showLeadingIcon
              ? Opacity(
                opacity: isLeadingDisabled ? 0.5 : 1,
                child: CustomIconButton(
                  icon: FontAwesomeIcons.angleLeft,
                  iconColor: leadingIconColor,
                  iconSize: kIconSizeMedium,
                  onPressed:
                      isLeadingDisabled
                          ? null
                          : onPressed ?? () => Navigator.pop(context),
                ),
              )
              : null),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(60 + (bottom?.preferredSize.height ?? 0));
}
