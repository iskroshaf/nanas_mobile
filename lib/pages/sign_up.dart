// lib/pages/sign_up.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/pages/sign_in.dart';
import 'package:nanas_mobile/services/auth.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:nanas_mobile/utils/validators.dart';
import 'package:nanas_mobile/widgets/custom_elevated_button.dart';
import 'package:nanas_mobile/widgets/custom_snack_bar.dart';
import 'package:nanas_mobile/widgets/custom_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isSignUp = false;

  Future<void> _signUp() async {
    setState(() {
      _isSignUp = true;
    });

    final isValid = await validateSignUpFields(
      context,
      _usernameController,
      _emailController,
      _passwordController,
      _confirmPasswordController,
    );

    if (!mounted) return;

    if (!isValid) {
      setState(() {
        _isSignUp = false;
      });
      return;
    }

    try {
      await signUp(
        _emailController.text.trim(),
        _passwordController.text,
        _usernameController.text.trim(),
      );

      if (!mounted) return;

      CustomSnackBar.show(
        context: context,
        message: 'Sign Up successfully',
        type: SnackBarType.success,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.show(
        context: context,
        message: e.toString(),
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSignUp = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: kPaddingBody,
          child: Column(
            children: [
              CustomTextField(
                isDisable: _isSignUp,
                controller: _usernameController,
                hintText: 'Username',
              ),
              const SizedBox(height: 8),
              CustomTextField(
                isDisable: _isSignUp,
                controller: _emailController,
                hintText: 'Email Address',
              ),
              const SizedBox(height: 8),
              CustomTextField(
                isDisable: _isSignUp,
                controller: _passwordController,
                hintText: 'Password',
                isObscureText: true,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                isDisable: _isSignUp,
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                isObscureText: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 35,
                width: double.infinity,
                child: CustomElevatedButton(
                  text: 'Sign Up',
                  onPressed: _signUp,
                  isLoading: _isSignUp,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap:
                        _isSignUp
                            ? null
                            : () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignIn(),
                                ),
                              );
                            },
                    child: Opacity(
                      opacity: _isSignUp ? 0.5 : 1.0,
                      child: Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
