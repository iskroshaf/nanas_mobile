// lib/widgets/custom_text_field.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:nanas_mobile/custom_widgets/custom_icon_button.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool isObscureText;
  final bool isNumber;
  final int maxLines;
  final InputBorder? border;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? height;
  final EdgeInsets? contentPadding;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final int minLines;
  final bool isDisable;

  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    required this.controller,
    this.focusNode,
    this.isObscureText = false,
    this.isNumber = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.border,
    this.prefixIcon,
    this.suffixIcon,
    this.height,
    this.contentPadding,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.isDisable = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscureText;

  @override
  void initState() {
    super.initState();
    _isObscureText = widget.isObscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return IgnorePointer(
      ignoring: widget.isDisable,
      child: Opacity(
        opacity: widget.isDisable ? 0.5 : 1,
        child: SizedBox(
          height: widget.height ?? (35.0 * widget.maxLines),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: _isObscureText,
            keyboardType:
                widget.isNumber ? TextInputType.number : TextInputType.text,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            style: textTheme.bodyMedium,
            decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: textTheme.bodyMedium?.copyWith(
                color:
                    isDark
                        ? kWhiteColor.withOpacity(0.35)
                        : kTextColorMedium.withOpacity(0.35),
              ),
              hintText: widget.hintText,
              hintStyle: textTheme.bodyMedium?.copyWith(
                color:
                    isDark
                        ? kWhiteColor.withOpacity(0.35)
                        : kTextColorMedium.withOpacity(0.35),
              ),
              filled: true,
              fillColor: isDark ? kSecondaryColor : kWhiteColor,
              contentPadding: widget.contentPadding ?? kPaddingInput,
              border: widget.border,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color:
                      isDark
                          ? kWhiteColor.withOpacity(0.25)
                          : Color(0xFFf3f4f6),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: kPrimaryColor, width: 1),
              ),
              prefixIcon:
                  widget.prefixIcon != null
                      ? IconTheme(
                        data: IconThemeData(
                          color: isDark ? kWhiteColor : kIconColor,
                          size: kIconSizeSmall,
                        ),
                        child: widget.prefixIcon!,
                      )
                      : null,
              suffixIcon:
                  widget.suffixIcon ??
                  (widget.isObscureText
                      ? CustomIconButton(
                        icon:
                            _isObscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                        onPressed: () {
                          setState(() {
                            _isObscureText = !_isObscureText;
                          });
                        },
                      )
                      : null),
            ),
          ),
        ),
      ),
    );
  }
}
