// lib/services/ent.dart

import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;
import 'package:nanas_mobile/utils/connectivities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String? _domain = dotenv.env['DOMAIN'];
final String? _port = dotenv.env['PORT'];

String get _baseUrl {
  if (_domain == null || _domain!.isEmpty) {
    throw "DOMAIN is not set in .env";
  }
  if (_port == null || _port!.isEmpty) {
    return '$_domain/api';
  }
  return '$_domain:$_port/api';
}

String _detectMimeType(String path) {
  final lower = path.toLowerCase();
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
    return 'image/jpeg';
  } else if (lower.endsWith('.png')) {
    return 'image/png';
  } else if (lower.endsWith('.gif')) {
    return 'image/gif';
  } else if (lower.endsWith('.webp')) {
    return 'image/webp';
  }
  return 'application/octet-stream';
}

class EntService {
  static Future<Map<String, dynamic>> getProfile() async {
    if (!await isOnline()) throw "No internet connection";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    if (token == null) throw "No access token found";

    final url = Uri.parse('$_baseUrl/v1/users/me/profile');

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw "Failed to load profile (${response.statusCode})";
    }

    final decoded = json.decode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    } else {
      throw "Invalid profile response format";
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String phoneNo,
    required String ic,
    File? imageFile,
  }) async {
    if (!await isOnline()) throw "No internet connection";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    if (token == null) throw "No access token found";

    final uri = Uri.parse('$_baseUrl/v1/users/me/profile/full');
    final request = http.MultipartRequest("PUT", uri);

    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    request.headers[HttpHeaders.acceptHeader] = 'application/json';

    request.fields['full_name'] = fullName;
    request.fields['phone_no'] = phoneNo;
    request.fields['ic'] = ic;

    if (imageFile != null) {
      final mime = _detectMimeType(imageFile.path); 
      final parts = mime.split('/');

      final multipartFile = await http.MultipartFile.fromPath(
        "file", 
        imageFile.path,
        contentType: MediaType(
          parts[0], 
          parts[1], 
        ),
      );

      request.files.add(multipartFile);
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error("Failed to update profile (${response.statusCode})");
    }

    final decoded = json.decode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    } else {
      throw "Invalid update response format";
    }
  }

  static Future<Map<String, dynamic>> getOwnerProfile() async {
    if (!await isOnline()) throw "No internet connection";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    final response = await http.get(
      Uri.parse('$_baseUrl/v1/users/me/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw "Failed to load owner profile";
    }

    return json.decode(response.body);
  }

  static Future<void> updateOwnerProfile({
    required String fullName,
    required String phoneNo,
    required String ic,
    File? profilePhoto,
  }) async {
    if (!await isOnline()) throw "No internet connection";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    final uri = Uri.parse('$_baseUrl/v1/users/me/profile/full');
    final request = http.MultipartRequest("PUT", uri);

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['full_name'] = fullName;
    request.fields['phone_no'] = phoneNo;
    request.fields['ic'] = ic;

    if (profilePhoto != null) {
      final mime = _detectMimeType(profilePhoto.path);
      final parts = mime.split("/");

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          profilePhoto.path,
          contentType: MediaType(parts[0], parts[1]), 
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw "Failed to update owner profile (${response.statusCode})";
    }
  }

  static Future<void> registerFarm({
    required String name,
    required String size,
    required String address,
    required String postcode,
    required String city,
    required String pineappleVariety,
    File? image,
  }) async {
    if (!await isOnline()) throw "No internet connection";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");

    final uri = Uri.parse('$_baseUrl/v1/farms/');
    final request = http.MultipartRequest("POST", uri);

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name;
    request.fields['size'] = size;
    request.fields['address'] = address;
    request.fields['postcode'] = postcode;
    request.fields['city'] = city;
    request.fields['pineapple_variety'] = pineappleVariety;

    if (image != null) {
      final mime = _detectMimeType(image.path); 
      final parts = mime.split("/");

      request.files.add(
        await http.MultipartFile.fromPath(
          "image",
          image.path,
          contentType: MediaType(parts[0], parts[1]), 
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw "Failed to register farm";
    }
  }
}
