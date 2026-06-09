import 'package:http/http.dart' as http;
import 'package:mi_tension/core/constants/ApiConstant.dart';
import 'package:mi_tension/core/storage/TokenStorage.dart';
import 'dart:convert';

class ApiClient {
  final String baseUrl = ApiConstant.baseUrl;

  Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.getToken();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  void _handleError(http.Response response) {
    if (response.body.isEmpty) {
      throw Exception(
        "Error ${response.statusCode}: respuesta vacía del servidor",
      );
    }
    try {
      final body = jsonDecode(response.body);
      throw Exception(
        body['mensaje'] ?? body['message'] ?? "Error ${response.statusCode}",
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    if (response.statusCode >= 400) _handleError(response);
    if (response.body.isEmpty) return {};
    return jsonDecode(response.body);
  }

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
    );
    if (response.statusCode >= 400) _handleError(response);
    if (response.body.isEmpty) return [];
    return jsonDecode(response.body);
  }

  Future<dynamic> put(String endpoint, dynamic body) async {
    final response = await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    if (response.statusCode >= 400) _handleError(response);
    if (response.body.isEmpty) return {};
    return jsonDecode(response.body);
  }

  Future<dynamic> delete(String endpoint, dynamic body) async {
    final response = await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
    if (response.statusCode >= 400) _handleError(response);
    if (response.body.isEmpty) return {};
    return jsonDecode(response.body);
  }
}
