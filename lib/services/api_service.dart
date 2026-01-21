import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/orange_type.dart';

class ApiService {
  // URL ของ backend API
  static const String baseUrl = 'http://localhost:8000';
  
  // ดึงข้อมูลส้มทั้งหมดจาก API
  Future<List<OrangeType>> fetchOranges() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/oranges'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => OrangeType.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load oranges');
      }
    } catch (e) {
      print('Error fetching oranges: $e');
      // Return local data as fallback
      return orangeTypes;
    }
  }
  
  // ดึงข้อมูลส้มตาม ID
  Future<OrangeType?> fetchOrangeById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/oranges/$id'));
      
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return OrangeType.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching orange by id: $e');
      return orangeTypes.firstWhere((o) => o.id == id);
    }
  }
  
  // คำนวณราคาผ่าน API
  Future<Map<String, dynamic>?> calculatePrice(String orangeId, double weight) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/calculate?orange_id=$orangeId&weight=$weight'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
      print('Error calculating price: $e');
      // Calculate locally as fallback
      final orange = orangeTypes.firstWhere((o) => o.id == orangeId);
      return {
        'orange_id': orangeId,
        'orange_name': orange.name,
        'weight': weight,
        'price_per_kg': orange.pricePerKg,
        'total_price': weight * orange.pricePerKg,
      };
    }
  }
  
  // ดึงราคาล่าสุด
  Future<List<Map<String, dynamic>>> fetchLivePrices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/prices'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load prices');
      }
    } catch (e) {
      print('Error fetching prices: $e');
      return [];
    }
  }
  
  // ตรวจสอบว่า API ทำงานหรือไม่
  Future<bool> checkApiStatus() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      return response.statusCode == 200;
    } catch (e) {
      print('API is not available: $e');
      return false;
    }
  }
}
