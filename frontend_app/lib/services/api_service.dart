import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

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
