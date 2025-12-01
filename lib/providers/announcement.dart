// lib/providers/announcement.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanas_mobile/models/announcement.dart' as model;
import 'package:nanas_mobile/services/announcement.dart';

final announcementProvider = FutureProvider<List<model.AnnouncementModel>>((
  ref,
) async {
  return AnnouncementService.loadAnnouncements();
});
