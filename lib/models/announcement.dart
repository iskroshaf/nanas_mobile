// lib/models/annoucement.dart

class AnnouncementModel {
  final int id;
  final String sender;
  final String farm;
  final String title;
  final String message;
  final DateTime timestamp;

  AnnouncementModel({
    required this.id,
    required this.sender,
    required this.farm,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'],
      sender: json['sender'],
      farm: json['farm'],
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestampz'] as String),
    );
  }
}
