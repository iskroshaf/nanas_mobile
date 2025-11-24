// lib/models/ven_shop.dart

class VenShop {
  final int id;
  final String name;
  final String desc;
  final double price;
  final String location;

  VenShop({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.location,
  });

  factory VenShop.fromJson(Map<String, dynamic> json) {
    return VenShop(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      price: json['price'],
      location: json['location'],
    );
  }
}
