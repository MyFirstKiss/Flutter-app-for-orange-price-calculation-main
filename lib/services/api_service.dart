import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/orange_type.dart';
import '../models/price_calculation.dart';

class ApiService {
  // URL ของ backend API
  static String get baseUrl {
    // สำหรับ Android Emulator ต้องใช้ 10.0.2.2
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8001';
    }
    return 'http://localhost:8001';
  }
  
  // ดึงข้อมูลส้มทั้งหมดจาก API
  Future<({List<OrangeType> oranges, bool isFromApi})> fetchOranges() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/oranges'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        final oranges = data.map((json) => OrangeType.fromJson(json)).toList();
        debugPrint('✅ Successfully fetched ${oranges.length} oranges from API');
        return (oranges: oranges, isFromApi: true);
      } else {
        debugPrint('⚠️ API returned status ${response.statusCode}');
        return (oranges: orangeTypes, isFromApi: false);
      }
    } catch (e) {
      debugPrint('❌ Error fetching oranges: $e');
      // Return local data as fallback
      return (oranges: orangeTypes, isFromApi: false);
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
      debugPrint('Error fetching orange by id: $e');
      return orangeTypes.firstWhere((o) => o.id == id);
    }
  }
  
  // คำนวณราคาผ่าน API
  Future<({Map<String, dynamic>? result, bool isFromApi})> calculatePrice(String orangeId, double weight) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/calculate?orange_id=$orangeId&weight=$weight'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final calculationResult = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        debugPrint('✅ Calculated via API: ${calculationResult['total_price']} บาท');
        return (result: calculationResult, isFromApi: true);
      } else {
        debugPrint('⚠️ API calculation failed with status ${response.statusCode}');
        return (result: null, isFromApi: false);
      }
    } catch (e) {
      debugPrint('❌ Error calculating price: $e');
      return (result: null, isFromApi: false);
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
      debugPrint('Error fetching prices: $e');
      return [];
    }
  }
  
  // ตรวจสอบว่า API ทำงานหรือไม่
  Future<bool> checkApiStatus() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('API is not available: $e');
      return false;
    }
  }

  // ดึงประวัติการคำนวณราคา
  Future<List<PriceCalculation>> fetchCalculations({int limit = 50}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/calculations?limit=$limit'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => PriceCalculation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load calculations');
      }
    } catch (e) {
      debugPrint('Error fetching calculations: $e');
      return [];
    }
  }

  // ดึงสถิติ
  Future<Map<String, dynamic>?> fetchStatistics() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/stats'));
      
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching statistics: $e');
      return null;
    }
  }

  // ลบประวัติการคำนวณราคา
  Future<bool> deleteCalculation(int calculationId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/calculations/$calculationId'),
      );
      
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('Failed to delete calculation: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error deleting calculation: $e');
      return false;
    }
  }
}
