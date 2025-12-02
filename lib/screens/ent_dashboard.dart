// lib/screens/home.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nanas_mobile/screens/announcements.dart';
import 'package:nanas_mobile/screens/chat.dart';
import 'package:nanas_mobile/screens/farms.dart';
import 'package:nanas_mobile/screens/home.dart';
import 'package:nanas_mobile/screens/settings.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';

class EntDashboard extends StatefulWidget {
  final int initialIndex;
  const EntDashboard({super.key, this.initialIndex = 1});

  @override
  State<EntDashboard> createState() => _EntDashboardState();
}

class _EntDashboardState extends State<EntDashboard> {
  late int _currentIndex;

  void _onTap(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? kBodyDarkColor : kBodyLightColor;
    final selectedColor = isDark ? kPrimaryColor : kPrimaryColor;
    final unselectedColor = isDark ? kWhiteColor : Color(0xFFd1d5db);
    final borderColor = isDark ? kLineDarkColor : kLineLightColor;

    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [Farms(), Announcements(), Home(), Chat(), Settings()],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: borderColor, width: 1)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: _onTap,
              backgroundColor: backgroundColor,
              selectedLabelStyle: textTheme.titleSmall,
              unselectedLabelStyle: textTheme.titleSmall,
              selectedItemColor: selectedColor,
              unselectedItemColor: unselectedColor,
              items: [
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.tractor, size: kIconSizeSmall),
                  label: 'Farms',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.bullhorn, size: kIconSizeSmall),
                  label: 'Annoucements',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.home, size: kIconSizeSmall),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.comment, size: kIconSizeSmall),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.gear, size: kIconSizeSmall),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
