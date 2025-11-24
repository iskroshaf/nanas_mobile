// lib/providers/ven_shops_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nanas_mobile/models/ven_shops.dart' as model;
import 'package:nanas_mobile/services/ven.dart';

final venShopsProvider = FutureProvider<List<model.VenShop>>((ref) async {
  return VenService.loadVenShops();
});

final shopSearchProvider = StateProvider<String>((ref) => '');
