// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/farm_model.dart';

// class FarmService {
//   static String get baseUrl {
//     final domain = dotenv.env['DOMAIN'];
//     final port = dotenv.env['PORT'];
//     return "$domain:$port/api/v1/farms/";
//   }

//   static Future<List<FarmModel>> getAllFarms() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("access_token");

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
