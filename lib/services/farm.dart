// // lib/services/farm.dart

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:nanas_mobile/utils/connectivities.dart';
// import '../models/farm_model.dart';

// final String? _domain = dotenv.env['DOMAIN']; // contoh: http://192.168.0.11
// final String? _port = dotenv.env['PORT']; // contoh: 8000

// String get _baseUrl {
//   if (_domain == null || _domain!.isEmpty) {
//     throw "DOMAIN is not set in .env";
//   }
//   if (_port == null || _port!.isEmpty) {
//     return '$_domain/api';
//   }
//   return '$_domain:$_port/api';
// }

// String _detectMimeType(String path) {
//   final lower = path.toLowerCase();
//   if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
//     return 'image/jpeg';
//   } else if (lower.endsWith('.png')) {
//     return 'image/png';
//   } else if (lower.endsWith('.gif')) {
//     return 'image/gif';
//   } else if (lower.endsWith('.webp')) {
//     return 'image/webp';
//   }
//   // fallback
//   return 'application/octet-stream';
// }

// class FarmService {
//   /// =============================
//   /// GET SEMUA FARM USER /v1/farms/me
//   /// dan pilih farm paling latest (id paling besar)
//   /// =============================
//   static Future<Map<String, dynamic>> getLatestFarmOfCurrentUser() async {
//     if (!await isOnline()) throw "No internet connection";

//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("access_token");
//     if (token == null) throw "No access token found";

//     final url = Uri.parse('$_baseUrl/v1/farms/me');

//     final res = await http.get(
//       url,
//       headers: {
//         HttpHeaders.authorizationHeader: 'Bearer $token',
//         HttpHeaders.acceptHeader: 'application/json',
//       },
//     );

//     if (res.statusCode < 200 || res.statusCode >= 300) {
//       throw "Failed to load farms (${res.statusCode})";
//     }

//     final decoded = json.decode(res.body);
//     if (decoded is! List || decoded.isEmpty) {
//       throw "No farms found for current user";
//     }

//     // Cari farm dengan id paling besar (latest)
//     Map<String, dynamic> latest = decoded.first as Map<String, dynamic>;
//     for (final item in decoded) {
//       final map = item as Map<String, dynamic>;
//       if ((map['id'] as int) > (latest['id'] as int)) {
//         latest = map;
//       }
//     }

//     // Contoh data:
//     // {
//     //   "name": "Golden Nenas",
//     //   "size": "5 hectors",
//     //   "address": "Jalan Bunga Raya",
//     //   "postcode": "78102",
//     //   "city": "Rawang",
//     //   "pineapple_variety": "Nenas md2",
//     //   "image_url": null,
//     //   "id": 3,
//     //   "owner_id": 1
//     // }

//     return latest;
//   }

//   /// =============================
//   // ignore: unintended_html_in_doc_comment
//   /// UPDATE FARM USER (PUT /v1/farms/<user_farm_id>)
//   /// Fields ikut curl:
//   /// - farm_name
//   /// - farm_size
//   /// - farm_address
//   /// - postcode
//   /// - city
//   /// - pineapple_variety
//   /// - year_business
//   /// - image (file)
//   /// =============================
//   static Future<Map<String, dynamic>> updateFarm({
//     required int farmId,
//     required String farmName,
//     required String farmSize,
//     required String farmAddress,
//     required String postcode,
//     required String city,
//     required String pineappleVariety,
//     required String yearBusiness,
//     File? imageFile,
//   }) async {
//     if (!await isOnline()) throw "No internet connection";

//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("access_token");
//     if (token == null) throw "No access token found";

//     final uri = Uri.parse('$_baseUrl/v1/farms/$farmId');

//     // Guna MultipartRequest dengan method PUT
//     final request = http.MultipartRequest("PUT", uri);

//     request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
//     request.headers[HttpHeaders.acceptHeader] = 'application/json';

//     // ⚠️ Ikut nama field dalam curl yang kau bagi
//     request.fields['farm_name'] = farmName;
//     request.fields['farm_size'] = farmSize;
//     request.fields['farm_address'] = farmAddress;
//     request.fields['postcode'] = postcode;
//     request.fields['city'] = city;
//     request.fields['pineapple_variety'] = pineappleVariety;
//     request.fields['year_business'] = yearBusiness;

//     if (imageFile != null) {
//       final mime = _detectMimeType(imageFile.path); // e.g. image/jpeg
//       final parts = mime.split('/');

//       final multipartFile = await http.MultipartFile.fromPath(
//         "image", // ikut curl: --form 'image=@"/path/file"'
//         imageFile.path,
//         contentType: MediaType(
//           parts[0], // 'image'
//           parts[1], // 'jpeg'
//         ),
//       );

//       request.files.add(multipartFile);
//     }

//     final streamed = await request.send();
//     final response = await http.Response.fromStream(streamed);

//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       return Future.error(
//         "Failed to update farm (${response.statusCode}) - ${response.body}",
//       );
//     }

//     final decoded = json.decode(response.body);
//     if (decoded is Map<String, dynamic>) {
//       // Response contoh:
//       // {
//       //   "name": "Taman Bunga Sendiri",
//       //   "size": "4 hector",
//       //   "address": "Lot 123, Jalan Kebun",
//       //   "postcode": "41000",
//       //   "city": "Rawang",
//       //   "pineapple_variety": "MD2",
//       //   "image_url": "/media/farm_images/xxx.jpg",
//       //   "id": 1,
//       //   "owner_id": 1
//       // }
//       return decoded;
//     } else {
//       throw "Invalid update farm response format";
//     }
//   }

//   /// =============================
//   /// GET semua farms (kau dah guna utk Featured Farms)
//   /// Endpoint: GET /api/v1/farms/
//   /// =============================
//   static String get baseUrl {
//     final domain = dotenv.env['DOMAIN'];
//     final port = dotenv.env['PORT'];
//     return "$domain:$port/api/v1/farms/";
//   }

//   static Future<List<FarmModel>> getAllFarms() async {
//     if (!await isOnline()) throw "No internet connection";

//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("access_token");
//     if (token == null) throw "No access token found";

//     final res = await http.get(
//       Uri.parse(baseUrl),
//       headers: {"Authorization": "Bearer $token"},
//     );

//     if (res.statusCode != 200) {
//       throw "Failed to load farms (${res.statusCode})";
//     }

//     final jsonList = json.decode(res.body) as List;

//     return jsonList.map((f) => FarmModel.fromJson(f)).toList();
//   }
// }

// lib/services/farm.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nanas_mobile/utils/connectivities.dart';
import '../models/farm_model.dart';

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

class FarmService {
  static Future<Map<String, dynamic>> getLatestFarmOfCurrentUser() async {
    if (!await isOnline()) throw "No internet connection";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    if (token == null) throw "No access token found";

    final url = Uri.parse('$_baseUrl/v1/farms/me');

    final res = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.acceptHeader: 'application/json',
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw "Failed to load farms (${res.statusCode})";
    }

    final decoded = json.decode(res.body);
    if (decoded is! List || decoded.isEmpty) {
      throw "No farms found for current user";
    }

    Map<String, dynamic> latest = decoded.first as Map<String, dynamic>;
    for (final item in decoded) {
      final map = item as Map<String, dynamic>;
      if ((map['id'] as int) > (latest['id'] as int)) {
        latest = map;
      }
    }

    // Debug (kalau nak tengok apa yang server hantar)
    // print('LATEST FARM: $latest');

    return latest;
  }

  static Future<Map<String, dynamic>> updateFarm({
    required int farmId,
    required String farmName,
    required String farmSize,
    required String farmAddress,
    required String postcode,
    required String city,
    required String pineappleVariety,
    File? imageFile,
  }) async {
    if (!await isOnline()) throw "No internet connection";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    if (token == null) throw "No access token found";

    final uri = Uri.parse('$_baseUrl/v1/farms/$farmId');

    final request = http.MultipartRequest("PUT", uri);

    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    request.headers[HttpHeaders.acceptHeader] = 'application/json';

    request.fields['farm_name'] = farmName;
    request.fields['farm_size'] = farmSize;
    request.fields['farm_address'] = farmAddress;
    request.fields['postcode'] = postcode;
    request.fields['city'] = city;
    request.fields['pineapple_variety'] = pineappleVariety;

    if (imageFile != null) {
      final mime = _detectMimeType(imageFile.path); 
      final parts = mime.split('/');

      final multipartFile = await http.MultipartFile.fromPath(
        "image", 
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
      return Future.error(
        "Failed to update farm (${response.statusCode}) - ${response.body}",
      );
    }

    final decoded = json.decode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    } else {
      throw "Invalid update farm response format";
    }
  }

  static String get baseUrl {
    final domain = dotenv.env['DOMAIN'];
    final port = dotenv.env['PORT'];
    return "$domain:$port/api/v1/farms/";
  }

  static Future<List<FarmModel>> getAllFarms() async {
    if (!await isOnline()) throw "No internet connection";

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    if (token == null) throw "No access token found";

    final res = await http.get(
      Uri.parse(baseUrl),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) {
      throw "Failed to load farms (${res.statusCode})";
    }

    final jsonList = json.decode(res.body) as List;

    return jsonList.map((f) => FarmModel.fromJson(f)).toList();
  }
}
