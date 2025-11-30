// lib/services/ven_shop.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:nanas_mobile/models/ven_shop.dart';

class VenShopService {
  static Future<List<VenShopModel>> loadVenShops() async {
    final String response = await rootBundle.loadString(
      'assets/data/ven_shops.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((shopJson) => VenShopModel.fromJson(shopJson)).toList();
  }
}
