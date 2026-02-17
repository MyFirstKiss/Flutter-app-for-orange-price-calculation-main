import 'package:flutter/material.dart';
import '../models/orange_type.dart';
import '../services/api_service.dart';

class DataScreen extends StatefulWidget {
  final Function(String) onNavigate;
  const DataScreen({super.key, required this.onNavigate});
  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final ApiService _apiService = ApiService();
  late OrangeType selectedOrange;
  List<OrangeType> availableOranges = orangeTypes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedOrange = orangeTypes[0];
    _loadOranges();
  }

  Future<void> _loadOranges() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final result = await _apiService.fetchOranges();
      if (!mounted) return;
      setState(() {
        availableOranges = result.oranges;
        if (result.oranges.isNotEmpty) selectedOrange = result.oranges[0];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Color get _orangeColor {
    switch (selectedOrange.id) {
      case 'green-sweet': return const Color(0xFF6B8E5A);
      case 'mandarin': return const Color(0xFFD4A443);
      default: return const Color(0xFFE8723A);
    }
  }

  Color get _orangeColorDark {
    switch (selectedOrange.id) {
      case 'green-sweet': return const Color(0xFF4A6B3A);
      case 'mandarin': return const Color(0xFFB8892E);
      default: return const Color(0xFFD4612E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final measurements = [
      {'icon': Icons.straighten_rounded, 'label': 'เธเธงเธฒเธกเธชเธนเธ', 'value': selectedOrange.height, 'unit': 'เธเธก.', 'color': const Color(0xFFE8723A), 'bg': const Color(0xFFFFEEE3)},
      {'icon': Icons.circle_outlined, 'label': 'เธฃเธฑเธจเธกเธต', 'value': selectedOrange.radius, 'unit': 'เธเธก.', 'color': const Color(0xFF9B7DB8), 'bg': const Color(0xFFF3EDFC)},
      {'icon': Icons.open_in_full_rounded, 'label': 'เน€เธชเนเธเธเนเธฒเธเธจเธนเธเธขเนเธเธฅเธฒเธ', 'value': selectedOrange.diameter, 'unit': 'เธเธก.', 'color': const Color(0xFF5B8FB9), 'bg': const Color(0xFFE4F0FB)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // โ”€โ”€ Gradient header โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_orangeColor, _orangeColorDark.withValues(alpha: 0.85), _orangeColor.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  child: Column(
                    children: [
                      // top bar
                      Row(
                        children: [
                          _circleButton(Icons.arrow_back_rounded, () => widget.onNavigate('home')),
                          const SizedBox(width: 14),
                          const Text('เธเนเธญเธกเธนเธฅเธ—เธตเนเธเธฑเธ”เน€เธเนเธ',
                              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (!isLoading) ...[
                        // Selector pills
                        Row(
                          children: availableOranges.map((orange) {
                            final isSelected = selectedOrange.id == orange.id;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => selectedOrange = orange),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset('assets/${orange.id}.png',
                                            width: 40, height: 40, fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => const Icon(Icons.circle, size: 40, color: Colors.white54)),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(orange.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                            color: isSelected ? _orangeColor : Colors.white,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        // Big orange image
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100, height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.2),
                                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8))],
                              ),
                              child: ClipOval(
                                child: Image.asset('assets/${selectedOrange.id}.png', fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.circle, size: 60, color: Colors.white54)),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(selectedOrange.name,
                                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text('เธเธธเธ“เธ เธฒเธ ${selectedOrange.grade ?? "A+"}',
                                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                                ),
                                const SizedBox(height: 6),
                                Text('เธฟ${selectedOrange.pricePerKg.toStringAsFixed(0)}/เธเธ.',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ],
                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // โ”€โ”€ Measurements โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€โ”€
            if (!isLoading) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('เธเธเธฒเธ”เนเธฅเธฐเธกเธดเธ•เธด',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF2D1B0E))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: measurements.map((item) {
                    final color = item['color'] as Color;
                    final bg = item['bg'] as Color;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.10), blurRadius: 14, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
                            child: Icon(item['icon'] as IconData, color: color, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(item['label'] as String,
                                style: const TextStyle(fontSize: 16, color: Color(0xFF6B5744), fontWeight: FontWeight.w500)),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text('${item['value']}',
                                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: color)),
                              const SizedBox(width: 4),
                              Text(item['unit'] as String,
                                  style: const TextStyle(fontSize: 14, color: Color(0xFF9C8B7A))),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Info note
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0E6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFFE8723A)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'เธเนเธญเธกเธนเธฅเน€เธเนเธเธเนเธฒเน€เธเธฅเธตเนเธขเธเธฒเธเธเธฒเธฃเธงเธฑเธ”${selectedOrange.name}เธเธธเธ“เธ เธฒเธเน€เธเธฃเธ” ${selectedOrange.grade ?? "A+"} เธกเธฒเธ•เธฃเธเธฒเธ',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF9C8B7A), height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
