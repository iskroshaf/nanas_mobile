// lib/screens/landing.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/screens/sign_in.dart';
import 'package:nanas_mobile/custom_widgets/custom_text_button.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomTextButton(
          text: 'Sign In',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignIn()),
            );
          },
        ),
      ),
    );
  }
}
