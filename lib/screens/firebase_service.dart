import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/price_calculation.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveCalculation({
    required String orangeType,
    required String orangeName,
    required double pricePerKg,
    required double weight,
    required double totalPrice,
  }) async {
    await _db.collection('calculations').add({
      'orangeType': orangeType,
      'orangeName': orangeName,
      'pricePerKg': pricePerKg,
      'weightKg': weight,
      'totalPrice': totalPrice,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<PriceCalculation>> watchHistory() {
    return _db
        .collection('calculations')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PriceCalculation.fromFirestore(doc))
            .toList());
  }

  Future<void> deleteCalculation(String docId) async {
    await _db.collection('calculations').doc(docId).delete();
  }
}
