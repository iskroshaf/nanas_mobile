// lib/services/chat_service.dart

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nanas_mobile/models/chat_message.dart';

final String? _domain = dotenv.env['DOMAIN']; 
final String? _port = dotenv.env['PORT']; 

class ChatService {
  static const String _storageKey = 'ai_chat_messages';
  static String get _apiUrl => '$_domain:$_port/api/v1/chat/';

  static Future<List<ChatMessage>> loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? messagesJson = prefs.getString(_storageKey);

      if (messagesJson == null) return [];

      final List<dynamic> decoded = json.decode(messagesJson);
      return decoded
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveMessages(List<ChatMessage> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listJson = messages.map((m) => m.toJson()).toList();
      await prefs.setString(_storageKey, json.encode(listJson));
    // ignore: empty_catches
    } catch (e) {

    }
  }

  static Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }


  static Future<String> sendMessageToAI(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    if (token == null) throw "No access token found";
    final res = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: json.encode({'message': message}),
    );

    // Debug optional
    // print('Response status: ${res.statusCode}');
    // print('Response body: ${res.body}');

    if (res.statusCode != 201) {
      throw Exception('Failed to send message (status: ${res.statusCode})');
    }

    final data = json.decode(res.body) as Map<String, dynamic>;
    final aiResponse = data['ai_response']?.toString() ?? 'No response';
    return aiResponse;
  }
}
