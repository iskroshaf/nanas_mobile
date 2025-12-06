// lib/screens/settings.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nanas_mobile/screens/farm_settings.dart';
import 'package:nanas_mobile/screens/profile_settings.dart';
import 'package:nanas_mobile/services/ent.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';

final String? domain = dotenv.env['DOMAIN'];
final String? port = dotenv.env['PORT'];

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, dynamic>? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await EntService.getProfile();
      setState(() {
        profile = data;
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

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
              decoration: const BoxDecoration(color: kPrimaryColor),
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Settings',
                            style: textTheme.titleLarge?.copyWith(
                              color: kWhiteColor,
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                // AVATAR
                                Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image:
                                          profile?["profile_photo"] != null
                                              ? NetworkImage(
                                                _buildFullImageURL(
                                                  profile!["profile_photo"],
                                                ),
                                              )
                                              : const AssetImage(
                                                    'assets/images/profile_placeholder.png',
                                                  )
                                                  as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                      color: kWhiteColor,
                                      width: 0.5,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 6),

                                // USERNAME
                                Text(
                                  profile?["username"]?.toString() ?? "-",
                                  style: textTheme.titleLarge?.copyWith(
                                    color: kWhiteColor,
                                  ),
                                ),

                                // EMAIL
                                Text(
                                  profile?["email"]?.toString() ?? "-",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: kWhiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
            ),

            Expanded(
              child: Container(
                padding: kPaddingBody.copyWith(top: 16, bottom: 16),
                width: double.infinity,
                decoration: const BoxDecoration(color: kWhiteColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSettingsOption(context, 'Profile', () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileSettings(),
                        ),
                      );
                      await _loadProfile();
                    }),
                    const SizedBox(height: 8),

                    // FARM SETTINGS
                    buildSettingsOption(context, 'Farm', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FarmSettings(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildFullImageURL(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    if (domain == null || domain!.isEmpty) return path;
    if (port == null || port!.isEmpty) {
      return '$domain$path';
    }
    return "$domain:$port$path";
  }
}

Widget buildSettingsOption(
  BuildContext context,
  String title,
  VoidCallback onTap,
) {
  final textTheme = Theme.of(context).textTheme;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: kPaddingInput,
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xfff9fafb),
        borderRadius: kBorderRadiusMedium,
      ),
      child: Row(
        children: [
          Text(title, style: textTheme.bodyMedium),
          const Spacer(),
          const FaIcon(
            FontAwesomeIcons.chevronRight,
            size: kIconSizeSmall,
            color: kIconColor,
          ),
        ],
      ),
    ),
  );
}
