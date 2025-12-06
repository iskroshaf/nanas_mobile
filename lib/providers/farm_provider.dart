// lib/providers/farm_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/farm_model.dart';
import '../services/farm.dart';

final farmProvider = FutureProvider<List<FarmModel>>((ref) async {
  return FarmService.getAllFarms();
});

final farmSearchProvider = StateProvider<String>((ref) => "");
