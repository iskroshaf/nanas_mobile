// lib/providers/ven_shop.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nanas_mobile/models/ven_shop.dart' as model;
import 'package:nanas_mobile/services/ven_shop.dart';

final venShopProvider = FutureProvider<List<model.VenShopModel>>((ref) async {
  return VenShopService.loadVenShops();
});

final shopSearchProvider = StateProvider<String>((ref) => '');
