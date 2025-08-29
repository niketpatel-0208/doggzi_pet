import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet.dart';
import '../config/api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiService {
  // Use the centralized API configuration
  static String get baseUrl => ApiConfig.baseUrl;

  static Future<Map<String, String>> _getHeaders({
    bool requiresAuth = false,
  }) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (requiresAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  static Future<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body);
      return fromJson(data);
    } else {
      String errorMessage = 'An error occurred';
      try {
        final errorData = json.decode(response.body);
        errorMessage = errorData['detail'] ?? errorMessage;
      } catch (e) {
        // If response body is not valid JSON, use status code
        errorMessage = 'Server error: ${response.statusCode}';
      }
      throw ApiException(errorMessage, response.statusCode);
    }
  }

  static Future<List<T>> _handleListResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => fromJson(item)).toList();
    } else {
      String errorMessage = 'An error occurred';
      try {
        final errorData = json.decode(response.body);
        errorMessage = errorData['detail'] ?? errorMessage;
      } catch (e) {
        errorMessage = 'Server error: ${response.statusCode}';
      }
      throw ApiException(errorMessage, response.statusCode);
    }
  }

  // Auth endpoints
  static Future<String> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: await _getHeaders(),
        body: json.encode({'email': email, 'password': password}),
      );

      final result = await _handleResponse(
        response,
        (data) => data['access_token'] as String,
      );

      // Save token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', result);
      await prefs.setString('user_email', email);

      return result;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  static Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: await _getHeaders(),
        body: json.encode({'email': email, 'password': password}),
      );

      final result = await _handleResponse(
        response,
        (data) => data['access_token'] as String,
      );

      // Save token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', result);
      await prefs.setString('user_email', email);

      return result;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_email');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  static Future<String?> getStoredEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  // Pet endpoints
  static Future<List<Pet>> getPets() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pets'),
        headers: await _getHeaders(requiresAuth: true),
      );

      return await _handleListResponse(response, (data) => Pet.fromJson(data));
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  static Future<Pet> createPet(PetCreate petData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pets'),
        headers: await _getHeaders(requiresAuth: true),
        body: json.encode(petData.toJson()),
      );

      return await _handleResponse(response, (data) => Pet.fromJson(data));
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}
