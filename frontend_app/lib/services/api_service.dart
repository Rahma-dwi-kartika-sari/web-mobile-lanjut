import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product.dart';

class ApiService {
  static const storage = FlutterSecureStorage();

  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // LOGIN
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      await storage.write(
        key: 'token',
        value: data['token'],
      );

      return true;
    }

    return false;
  }

  // MENGAMBIL PROFILE MENGGUNAKAN TOKEN
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return Map<String, dynamic>.from(data['data']);
    } else {
      throw Exception('Gagal mengambil data profile');
    }
  }

  // MENGAMBIL DATA PRODUK
  static Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData =
          jsonDecode(response.body);

      final List<dynamic> data = jsonData['data'];

      return data
          .map((item) => Product.fromJson(item))
          .toList();
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }
}