import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/orange_type.dart';
import '../services/api_service.dart';
import 'firebase_service.dart';

class CalculatorScreen extends StatefulWidget {
  final Function(String) onNavigate;
  const CalculatorScreen({super.key, required this.onNavigate});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final ApiService _apiService = ApiService();
  final FirebaseService _firebaseService = FirebaseService();
  late OrangeType selectedOrange;
  List<OrangeType> availableOranges = orangeTypes;
  final TextEditingController weightController = TextEditingController();
  double? totalPrice;
  bool isLoading = true;
  bool isCalculating = false;
  bool isApiConnected = false;

  @override
  void initState() {
    super.initState();
    selectedOrange = orangeTypes[0];
    _loadOranges();
  }

  Future<void> _loadOranges() async {
    setState(() => isLoading = true);
    final status = await _apiService.checkApiStatus();
    final result = await _apiService.fetchOranges();
    setState(() {
      isApiConnected = status;
      availableOranges = result.oranges;
      if (result.oranges.isNotEmpty) selectedOrange = result.oranges[0];
      isLoading = false;
    });
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  Future<void> handleCalculate() async {
    final weight = double.tryParse(weightController.text);
    if (weight == null || weight <= 0) return;
    setState(() => isCalculating = true);
    try {
      final apiResult = await _apiService.calculatePrice(selectedOrange.id, weight);
      final calculatedTotal = apiResult.result != null
          ? (apiResult.result!['total_price'] as num).toDouble()
          : weight * selectedOrange.pricePerKg;
      setState(() {
        totalPrice = calculatedTotal;
        isCalculating = false;
      });
      try {
        await _firebaseService.saveCalculation(
          orangeType: selectedOrange.id,
          orangeName: selectedOrange.name,
          pricePerKg: selectedOrange.pricePerKg,
          weight: weight,
          totalPrice: calculatedTotal,
        );
      } catch (_) {}
    } catch (e) {
      setState(() {
        totalPrice = weight * selectedOrange.pricePerKg;
        isCalculating = false;
      });
    }
  }

  void handleClear() => setState(() { weightController.clear(); totalPrice = null; });

  Color _colorFor(OrangeType o) {
    switch (o.id) {
      case 'green-sweet': return const Color(0xFF6B8E5A);
      case 'mandarin': return const Color(0xFFD4A443);
      default: return const Color(0xFFE8723A);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // โ”€โ”€ Gradient header โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6B8E5A), Color(0xFF8FB876), Color(0xFF6B8E5A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _circleBtn(Icons.arrow_back_rounded, () => widget.onNavigate('home')),
                          const SizedBox(width: 14),
                          const Text('เธเธณเธเธงเธ“เธฃเธฒเธเธฒ',
                              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                          const Spacer(),
                          // API status badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(isApiConnected ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                                    size: 14, color: Colors.white),
                                const SizedBox(width: 5),
                                Text(isApiConnected ? 'เน€เธเธทเนเธญเธกเธ•เนเธญ API เธชเธณเน€เธฃเนเธ' : 'Offline',
                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // price card inside header
                      if (!isLoading)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.sell_rounded, color: Colors.white, size: 28),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('เธฃเธฒเธเธฒเธ•เนเธญเธเธดเนเธฅเธเธฃเธฑเธก',
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                                  Text('${selectedOrange.pricePerKg.toStringAsFixed(1)} เธเธฒเธ—',
                                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(color: Color(0xFF6B8E5A)),
              )
            else ...[
              // โ”€โ”€ Orange selector โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Align(alignment: Alignment.centerLeft,
                  child: Text('เน€เธฅเธทเธญเธเธเธเธดเธ”เธเธฅเธชเนเธก',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2D1B0E)))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: availableOranges.map((orange) {
                    final isSelected = selectedOrange.id == orange.id;
                    final c = _colorFor(orange);
                    return GestureDetector(
                      onTap: () => setState(() { selectedOrange = orange; totalPrice = null; }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected ? c.withValues(alpha: 0.08) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? c : const Color(0xFFF0E4D8),
                            width: isSelected ? 2 : 1.5,
                          ),
                          boxShadow: [BoxShadow(color: c.withValues(alpha: isSelected ? 0.15 : 0.05), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset('assets/${orange.id}.png', width: 48, height: 48, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(width: 48, height: 48,
                                      decoration: BoxDecoration(color: c.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)))),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(orange.name,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                                          color: isSelected ? c : const Color(0xFF2D1B0E))),
                                  Text('${orange.pricePerKg.toStringAsFixed(0)} เธเธฒเธ—/เธเธ.',
                                      style: TextStyle(fontSize: 13, color: isSelected ? c.withValues(alpha: 0.7) : const Color(0xFF9C8B7A))),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 26, height: 26,
                                decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                                child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // โ”€โ”€ Weight input โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 10),
                child: Align(alignment: Alignment.centerLeft,
                  child: Text('เธเนเธณเธซเธเธฑเธ (เธเธดเนเธฅเธเธฃเธฑเธก)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2D1B0E)))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF6B8E5A), width: 2),
                    boxShadow: [BoxShadow(color: const Color(0xFF6B8E5A).withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: TextField(
                    controller: weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF2D1B0E)),
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      hintStyle: TextStyle(color: Color(0xFFBBB0A5), fontSize: 28),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
              ),

              // โ”€โ”€ Buttons โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: isCalculating ? null : handleCalculate,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF6B8E5A), Color(0xFF8FB876)]),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: const Color(0xFF6B8E5A).withValues(alpha: 0.35), blurRadius: 14, offset: const Offset(0, 6))],
                          ),
                          child: Center(
                            child: isCalculating
                                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                : const Text('เธเธณเธเธงเธ“', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: handleClear,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFF0E4D8), width: 1.5),
                          ),
                          child: const Center(
                            child: Text('เธฅเนเธฒเธ', style: TextStyle(color: Color(0xFF6B5744), fontSize: 18, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // โ”€โ”€ Result card โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€
              if (totalPrice != null) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE8723A), Color(0xFFFF9A5C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: const Color(0xFFE8723A).withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: Column(
                        children: [
                          Text('เธฃเธฒเธเธฒเธฃเธงเธกเธ—เธฑเนเธเธซเธกเธ”',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 15)),
                          const SizedBox(height: 6),
                          Text(totalPrice!.toStringAsFixed(2),
                              style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w800)),
                          const Text('เธเธฒเธ—', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 16),
                          Container(height: 1, color: Colors.white.withValues(alpha: 0.3)),
                          const SizedBox(height: 14),
                          _resultRow('เธเธเธดเธ”', selectedOrange.name),
                          const SizedBox(height: 8),
                          _resultRow('เธเนเธณเธซเธเธฑเธ', '${weightController.text} เธเธ.'),
                          const SizedBox(height: 8),
                          _resultRow('เธฃเธฒเธเธฒ/เธเธ.', '${selectedOrange.pricePerKg.toStringAsFixed(0)} เธเธฒเธ—'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40, height: 40,
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 22),
    ),
  );

  Widget _resultRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
    ],
  );
}
