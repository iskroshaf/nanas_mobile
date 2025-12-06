// lib/models/announcement.dart

class AnnouncementModel {
  final int id;
  final String sender;
  final String farm;
  final String title;
  final String message;
  final DateTime timestamp;
  final String? imageUrl;
  final String? ownerPhoneNo;

  AnnouncementModel({
    required this.id,
    required this.sender,
    required this.farm,
    required this.title,
    required this.message,
    required this.timestamp,
    this.imageUrl,
    this.ownerPhoneNo,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'] as Map<String, dynamic>?;
    final farm = json['farm'] as Map<String, dynamic>?;

    return AnnouncementModel(
      id: json['id'] as int,
      sender:
          (owner?['full_name'] as String?) ??
          (owner?['username'] as String?) ??
          'Unknown',
      farm: (farm?['name'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      message: (json['description'] as String?) ?? '',
      timestamp: DateTime.parse(json['created_at'] as String),
      imageUrl:
          (json['image_url'] as String?) ?? (farm?['image_url'] as String?),
      ownerPhoneNo: owner?['phone_no'] as String?,
    );
  }
}
