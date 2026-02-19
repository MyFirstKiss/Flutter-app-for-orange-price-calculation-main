import 'package:cloud_firestore/cloud_firestore.dart';

class PriceCalculation {
  final int id;
  final String? docId;
  final String orangeType;
  final String orangeName;
  final double weightKg;
  final double pricePerKg;
  final double totalPrice;
  final DateTime date;

  PriceCalculation({
    required this.id,
    this.docId,
    required this.orangeType,
    required this.orangeName,
    required this.weightKg,
    required this.pricePerKg,
    required this.totalPrice,
    required this.date,
  });

  // สร้าง PriceCalculation จาก JSON
  factory PriceCalculation.fromJson(Map<String, dynamic> json) {
    return PriceCalculation(
      id: json['id'],
      orangeType: json['orange_type'],
      orangeName: json['orange_name'] ?? '',
      weightKg: (json['weight_kg'] as num).toDouble(),
      pricePerKg: (json['price_per_kg'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  // สร้าง PriceCalculation จาก Firestore DocumentSnapshot
  factory PriceCalculation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PriceCalculation(
      id: 0,
      docId: doc.id,
      orangeType: data['orangeType'] ?? data['orange_type'] ?? '',
      orangeName: data['orangeName'] ?? data['orange_name'] ?? '',
      weightKg: (data['weightKg'] ?? data['weight_kg'] as num? ?? 0).toDouble(),
      pricePerKg: (data['pricePerKg'] ?? data['price_per_kg'] as num? ?? 0).toDouble(),
      totalPrice: (data['totalPrice'] ?? data['total_price'] as num? ?? 0).toDouble(),
      date: data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate()
          : data['date'] != null
              ? (data['date'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }

  // แปลง PriceCalculation เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orange_type': orangeType,
      'orange_name': orangeName,
      'weight_kg': weightKg,
      'price_per_kg': pricePerKg,
      'total_price': totalPrice,
      'date': date.toIso8601String(),
    };
  }
}

