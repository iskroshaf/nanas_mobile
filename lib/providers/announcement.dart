// lib/providers/announcement.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanas_mobile/models/announcement.dart';
import 'package:nanas_mobile/services/announcement.dart';

final announcementProvider =
    FutureProvider.autoDispose<List<AnnouncementModel>>((ref) async {
      return AnnouncementService.fetchAnnouncements();
    });

final myAnnouncementProvider = FutureProvider<List<AnnouncementModel>>((
  ref,
) async {
  return AnnouncementService.fetchMyAnnouncements();
});
