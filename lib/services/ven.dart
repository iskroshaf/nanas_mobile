// lib/services/ven.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:nanas_mobile/models/ven_shops.dart';

class VenService {
  static Future<List<VenShop>> loadVenShops() async {
    final String response = await rootBundle.loadString(
      'assets/data/ven_shops.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((shopJson) => VenShop.fromJson(shopJson)).toList();
  }
}
