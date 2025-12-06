// lib/services/auth.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nanas_mobile/utils/connectivities.dart';
import 'dart:developer' as developer;

final String? domain = dotenv.env['DOMAIN'];
final String? port = dotenv.env['PORT'];
final String baseUrl = '$domain:$port/api';

class AuthService {
  static Future<void> signUp(
    String email,
    String password,
    String username,
  ) async {
    if (!await isOnline()) {
      throw "No internet connection";
    }

    try {
      final userData = {
        "username": username,
        "email": email,
        "password": password,
        "confirm_password": password, 
      };

      final response = await http.post(
        Uri.parse('$baseUrl/v1/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      developer.log('Signup API fetched');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final body = json.decode(response.body);
        throw body["message"] ?? "Failed to sign up";
      }
    } catch (e) {
      developer.log('Signup Error: $e');
      throw e.toString();
    }
  }

  static Future<void> signIn(String email, String password) async {
    if (!await isOnline()) {
      throw "No internet connection";
    }

    try {
      final body = {"email": email, "password": password};

      final response = await http.post(
        Uri.parse('$baseUrl/v1/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      developer.log("Login API fetched");

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final resBody = json.decode(response.body);

        if (resBody["detail"] is List && resBody["detail"].isNotEmpty) {
          throw resBody["detail"][0]["msg"] ?? "Failed to login";
        }

        throw resBody["detail"] ?? "Failed to login";
      }

      final data = json.decode(response.body);
      final token = data["access_token"];

      if (token == null) {
        throw "Token not found in response";
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", token);
    } catch (e) {
      developer.log("Login Error: $e");
      throw e.toString();
    }
  }
}
