// lib/screens/sign_in.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/screens/ent_dashboard.dart';
import 'package:nanas_mobile/screens/sign_up.dart';
import 'package:nanas_mobile/services/auth.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';
import 'package:nanas_mobile/custom_widgets/custom_elevated_button.dart';
import 'package:nanas_mobile/custom_widgets/custom_snack_bar.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSignIn = false;

  Future<void> _signIn() async {
    setState(() {
      _isSignIn = true;
    });

    // final isValid = await validateSignInFields(
    //   context,
    //   _emailController,
    //   _passwordController,
    // );

    if (!mounted) return;

    // if (!isValid) {
    //   setState(() {
    //     _isSignIn = false;
    //   });
    //   return;
    // }

    try {
      await signIn(_emailController.text.trim(), _passwordController.text);

      if (!mounted) return;

      CustomSnackBar.show(
        context: context,
        message: 'Sign In successfully',
        type: SnackBarType.success,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EntLanding()),
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
          _isSignIn = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                isDisable: _isSignIn,
                controller: _emailController,
                hintText: 'Email Address',
              ),
              const SizedBox(height: 8),
              CustomTextField(
                isDisable: _isSignIn,
                controller: _passwordController,
                hintText: 'Password',
                isObscureText: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 35,
                width: double.infinity,
                child: CustomElevatedButton(
                  text: 'Sign In',
                  onPressed: _signIn,
                  isLoading: _isSignIn,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap:
                        _isSignIn
                            ? null
                            : () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ),
                              );
                            },
                    child: Opacity(
                      opacity: _isSignIn ? 0.5 : 1.0,
                      child: Text(
                        'Sign Up',
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
