// lib/sevices/ent.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nanas_mobile/services/auth.dart';
import 'package:nanas_mobile/utils/connectivities.dart';
import 'dart:developer' as developer;

class EntService {
  static Future<void> updateProfile({required String fullname}) async {
    try {
      if (!await isOnline()) throw Exception("No internet connection.");

      final response = await http.patch(
        Uri.parse('$baseUrl/'),
        headers: {'Authorization': '', 'Content-Type': 'application/json'},
        body: jsonEncode({}),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {}
    } catch (e) {
      developer.log('API Error: $e');
    }
  }
}
