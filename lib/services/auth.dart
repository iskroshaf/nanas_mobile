// lib/services/auth.dart

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nanas_mobile/utils/connectivities.dart';
import 'dart:developer' as developer;

final String? domain = dotenv.env['DOMAIN'];
final String? port = dotenv.env['PORT'];
final String baseUrl = '$domain:$port/api';

Future<void> signUp(String email, String password, String username) async {
  if (!await isOnline()) {
    throw "No internet connection";
  }

  try {
    final userData = {
      'username': username,
      'email': email,
      'password': password,
    };

    final response = await http.post(
      Uri.parse(''),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    developer.log('API fetched');

    if (response.statusCode < 200 || response.statusCode >= 300) {}
  } catch (e) {
    developer.log('API Error: $e');
  }
}

Future<void> signIn(String email, String password) async {
  if (!await isOnline()) {
    throw "No internet connection";
  }
  try {} catch (e) {
    developer.log('Error: ${e.toString()}');
  }
}
