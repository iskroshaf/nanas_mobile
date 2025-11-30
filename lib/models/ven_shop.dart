// lib/models/ven_shop.dart

class VenShopModel {
  final int id;
  final String name;
  final String desc;
  final double price;
  final String location;

  VenShopModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.location,
  });

  factory VenShopModel.fromJson(Map<String, dynamic> json) {
    return VenShopModel(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      price: json['price'],
      location: json['location'],
    );
  }
}
