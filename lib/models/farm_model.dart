// lib/models/farm_model.dart

class FarmModel {
  final int id;
  final String name;
  final String size;
  final String address;
  final String postcode;
  final String city;
  final String pineappleVariety;
  final String? imageUrl;

  final String? ownerPhoneNo;

  FarmModel({
    required this.id,
    required this.name,
    required this.size,
    required this.address,
    required this.postcode,
    required this.city,
    required this.pineappleVariety,
    this.imageUrl,
    this.ownerPhoneNo, // ⬅️ baru
  });

  factory FarmModel.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'];

    return FarmModel(
      id: json['id'],
      name: json['name'],
      size: json['size'],
      address: json['address'],
      postcode: json['postcode'],
      city: json['city'],
      pineappleVariety: json['pineapple_variety'],
      imageUrl: json['image_url'],
      ownerPhoneNo: owner != null ? owner['phone_no'] as String? : null,
    );
  }
}
