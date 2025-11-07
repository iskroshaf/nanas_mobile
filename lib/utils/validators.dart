import 'package:flutter/material.dart';
import 'package:nanas_mobile/custom_widgets/custom_snack_bar.dart';

bool isEmpty(String value) {
  return value.isEmpty;
}

bool validateEmail(String email) {
  if (email.isEmpty) return false;
  String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
  return RegExp(emailPattern).hasMatch(email);
}

bool validatePassword(String password) {
  if (password.isEmpty) return false;
  return password.length >= 6;
}

bool validatePasswordMatch(String password, String confirmPassword) {
  return password == confirmPassword;
}

Future<bool> validateSignUpFields(
  BuildContext context,
  TextEditingController usernameController,
  TextEditingController emailController,
  TextEditingController passwordController,
  TextEditingController confirmPasswordController,
) async {
  if (isEmpty(usernameController.text.trim())) {
    CustomSnackBar.show(
      context: context,
      message: 'Please enter your username.',
      type: SnackBarType.warning,
    );
    return false;
  }

  if (isEmpty(emailController.text.trim())) {
    CustomSnackBar.show(
      context: context,
      message: 'Please enter your email address.',
      type: SnackBarType.warning,
    );
    return false;
  }

  if (!validateEmail(emailController.text.trim())) {
    CustomSnackBar.show(
      context: context,
      message: 'Please enter a valid email address.',
      type: SnackBarType.error,
    );
    return false;
  }

  if (isEmpty(passwordController.text.trim())) {
    CustomSnackBar.show(
      context: context,
      message: 'Please enter your password.',
      type: SnackBarType.warning,
    );
    return false;
  }

  if (!validatePassword(passwordController.text.trim())) {
    CustomSnackBar.show(
      context: context,
      message: 'Password should be at least 6 characters.',
      type: SnackBarType.warning,
    );
    return false;
  }

  if (isEmpty(confirmPasswordController.text.trim())) {
    CustomSnackBar.show(
      context: context,
      message: 'Please confirm your password.',
      type: SnackBarType.warning,
    );
    return false;
  }

  if (!validatePasswordMatch(
    passwordController.text.trim(),
    confirmPasswordController.text.trim(),
  )) {
    CustomSnackBar.show(
      context: context,
      message: 'Passwords do not match.',
      type: SnackBarType.error,
    );
    return false;
  }

  FocusScope.of(context).unfocus();
  return true;
}

Future<bool> validateSignInFields(
  BuildContext context,
  TextEditingController emailController,
  TextEditingController passwordController,
) async {
  if (isEmpty(emailController.text.trim())) {
    CustomSnackBar.show(
      context: context,
      message: 'Please enter your email address.',
      type: SnackBarType.warning,
    );
    return false;
  }
  if (!validateEmail(emailController.text.trim())) {
    CustomSnackBar.show(
      context: context,
      message: 'Please enter a valid email address.',
      type: SnackBarType.error,
    );
    return false;
  }
  if (isEmpty(passwordController.text.trim())) {
    CustomSnackBar.show(
      context: context,
      message: 'Please enter your password.',
      type: SnackBarType.warning,
    );
    return false;
  }
  FocusScope.of(context).unfocus();
  return true;
}
