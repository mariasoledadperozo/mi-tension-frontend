import 'package:http/http.dart' as http;
import 'package:mi_tension/core/storage/TokenStorage.dart';
import 'dart:convert';

class ApiClient {
  final String baseUrl = "http://localhost:5129/api";

  Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.getToken();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    if (response.statusCode >= 400) throw Exception(response.body);
    if (response.body.isEmpty) return {};
    return jsonDecode(response.body);
  }

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
    );
    if (response.statusCode >= 400) throw Exception(response.body);
    if (response.body.isEmpty) return [];
    return jsonDecode(response.body);
  }

  Future<dynamic> put(String endpoint, dynamic body) async {
    final response = await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    if (response.statusCode >= 400) throw Exception(response.body);
    if (response.body.isEmpty) return {};
    return jsonDecode(response.body);
  }

  Future<dynamic> delete(String endpoint, dynamic body) async {
    final response = await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
    if (response.statusCode >= 400) throw Exception(response.body);
    if (response.body.isEmpty) return {};
    return jsonDecode(response.body);
  }
}
