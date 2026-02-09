import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coffee_shop.dart';

class ApiService {
  // PASTE YOUR NPOINT LINK HERE! vvvvv
  static const String _url = "https://api.npoint.io/953190699f71a62784d3"; 

  // Fetch Coffee Shops
  static Future<List<CoffeeShop>> getCoffeeShops() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> shopsJson = data['shops'];

        return shopsJson.map((json) => CoffeeShop.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error fetching coffee shops: $e");
    }
  }

  // Fetch Promos (We return a simple list of Maps for now)
  static Future<List<Map<String, dynamic>>> getPromos() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> promosJson = data['promos'];

        // Convert to List<Map>
        return promosJson.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception("Failed to load promos");
      }
    } catch (e) {
      return []; // Return empty list on error
    }
  }
}