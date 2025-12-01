// lib/services/announcement.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:nanas_mobile/models/announcement.dart';

class AnnouncementService {
  static Future<List<AnnouncementModel>> loadAnnouncements() async {
    final String response = await rootBundle.loadString(
      'assets/data/announcements.json',
    );
    final List<dynamic> data = json.decode(response);
    return data
        .map((announcementJson) => AnnouncementModel.fromJson(announcementJson))
        .toList();
  }
}
