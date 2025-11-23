// lib/screens/home.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/styles/sizes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final int itemData = 50;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kPaddingBody,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: itemData,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  if (index == 0) SizedBox(height: 10),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: kBorderRadiusMedium,
                    ),
                    child: Center(
                      child: Text(
                        'Home ${index + 1}',
                        style: TextStyle(color: Color(0xffffffff)),
                      ),
                    ),
                  ),
                  if (index == itemData - 1) SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
