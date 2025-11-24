// lib/screens/profile.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/screens/profile_settings.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: kPaddingBody.copyWith(top: 16, bottom: 16),
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(color: kPrimaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: textTheme.titleLarge?.copyWith(color: kWhiteColor),
                  ),
                  SizedBox(height: 6),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/meWithBajuMelayu.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(color: kWhiteColor, width: 1),
                          ),
                        ),

                        SizedBox(height: 6),
                        Text(
                          'iskndrrosmi',
                          style: textTheme.titleLarge?.copyWith(
                            color: kWhiteColor,
                          ),
                        ),
                        Text(
                          'iskroshaf@gmail.com',
                          style: textTheme.bodyMedium?.copyWith(
                            color: kWhiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhiteColor.withOpacity(0.25),
                        borderRadius: kBorderRadiusMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: kPaddingBody.copyWith(top: 16, bottom: 16),
                width: double.infinity,
                decoration: BoxDecoration(color: kWhiteColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'General',
                      style: textTheme.titleMedium?.copyWith(
                        color: kTextColorMedium,
                      ),
                    ),
                    SizedBox(height: 10),
                    buildProfileOption(context, 'Profile Settings', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileSettings(),
                        ),
                      );
                    }),
                    SizedBox(height: 10),
                    buildProfileOption(context, 'Notifications', () {}),
                    SizedBox(height: 10),
                    buildProfileOption(context, 'Privacy', () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildProfileOption(
  BuildContext context,
  String title,
  VoidCallback onTap,
) {
  final textTheme = Theme.of(context).textTheme;
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: kPaddingInput,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xfff9fafb),
        borderRadius: kBorderRadiusMedium,
      ),
      child: Row(
        children: [
          Text(title, style: textTheme.titleMedium),
          Spacer(),
          FaIcon(
            FontAwesomeIcons.chevronRight,
            size: kIconSizeSmall,
            color: kIconColor,
          ),
        ],
      ),
    ),
  );
}
