import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product.dart';

class ApiService {
  static const storage = FlutterSecureStorage();

  static const String baseUrl =
      'https://web-mobile-lanjut.vercel.app/api';

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

  // MENAMBAH PRODUK
  static Future<bool> addProduct(
    String name,
    double price,
    int stock,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'stock': stock,
      }),
    );

    return response.statusCode == 201;
  }

  // MENGUBAH PRODUK
  static Future<bool> updateProduct(
    int id,
    String name,
    double price,
    int stock,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'stock': stock,
      }),
    );

    return response.statusCode == 200;
  }

  // MENGHAPUS PRODUK
  static Future<bool> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: {
        'Accept': 'application/json',
      },
    );

    return response.statusCode == 200 ||
        response.statusCode == 204;
  }
}