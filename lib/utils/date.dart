// lib/utils/date.dart

import 'package:intl/intl.dart';

String formatTimestamp(dynamic timestamp) {
  DateTime dateTime;

  if (timestamp is Map<String, dynamic>) {
    final seconds = timestamp['_seconds'] ?? timestamp['seconds'];
    final nanoseconds =
        timestamp['_nanoseconds'] ?? timestamp['nanoseconds'] ?? 0;
    dateTime = DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000 + (nanoseconds ~/ 1000000),
    );
  } else if (timestamp is String) {
    dateTime = DateTime.parse(timestamp);
  } else if (timestamp is DateTime) {
    dateTime = timestamp;
  } else {
    return 'Invalid date';
  }

  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    final mins = difference.inMinutes;
    return '$mins minute${mins > 1 ? 's' : ''} ago';
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    return '$hours hour${hours > 1 ? 's' : ''} ago';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    final days = difference.inDays;
    return '$days day${days > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 365) {
    return DateFormat('d MMM').format(dateTime);
  } else {
    return DateFormat('d MMM yyyy').format(dateTime);
  }
}
