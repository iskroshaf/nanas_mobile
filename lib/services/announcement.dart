// lib/services/announcement.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nanas_mobile/models/announcement.dart';
import 'package:nanas_mobile/utils/connectivities.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class AnnouncementService {
  static Future<List<AnnouncementModel>> fetchAnnouncements() async {
    if (!await isOnline()) throw "No internet connection";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    if (token == null) throw "No access token found";

    final uri = Uri.parse('$_baseUrl/v1/announcements/');
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw "Failed to load announcements (${response.statusCode})";
    }

    final decoded = json.decode(response.body);
    if (decoded is! List) {
      throw "Invalid announcements response format";
    }

    return decoded
        .map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<AnnouncementModel>> fetchMyAnnouncements() async {
    if (!await isOnline()) throw "No internet connection";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    if (token == null) throw "No access token found";

    final uri = Uri.parse('$_baseUrl/v1/announcements/me');
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw "Failed to load my announcements (${response.statusCode})";
    }

    final decoded = json.decode(response.body);
    if (decoded is! List) {
      throw "Invalid my-announcements response format";
    }

    return decoded
        .map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> deleteAnnouncement(int id) async {
    if (!await isOnline()) throw "No internet connection";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    if (token == null) throw "No access token found";

    final uri = Uri.parse('$_baseUrl/v1/announcements/$id');
    final response = await http.delete(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw "Failed to delete announcement (${response.statusCode})";
    }
  }

  static Future<int?> _getMyFarmIdFromFarmsMe() async {
    if (!await isOnline()) throw "No internet connection";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    if (token == null) throw "No access token found";

    final uri = Uri.parse('$_baseUrl/v1/farms/me');
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw "Failed to load my farms (${response.statusCode})";
    }

    final decoded = json.decode(response.body);
    if (decoded is! List || decoded.isEmpty) {
      return null;
    }

    final farm = decoded.first as Map<String, dynamic>;
    final farmId = farm['id'] as int?;
    return farmId;
  }

  static Future<void> createAnnouncement({
    required String title,
    required String description,
    File? imageFile,
    int? yearInBusiness,
    int? farmIdOverride,
  }) async {
    if (!await isOnline()) throw "No internet connection";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    if (token == null) throw "No access token found";

    final farmId = farmIdOverride ?? await _getMyFarmIdFromFarmsMe();

    if (farmId == null) {
      throw "Cannot determine farm_id. Pastikan anda sudah ada farm atau pass farmIdOverride.";
    }

    final uri = Uri.parse('$_baseUrl/v1/announcements/');

    final request = http.MultipartRequest('POST', uri);
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['year_in_business'] = (yearInBusiness ?? 2003).toString();
    request.fields['farm_id'] = farmId.toString(); 

    if (imageFile != null) {
      final fileName = imageFile.path.split('/').last;
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: fileName,
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);


    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw "Failed to create announcement (${response.statusCode})";
    }
  }
}
