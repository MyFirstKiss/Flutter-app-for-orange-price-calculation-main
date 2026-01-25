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
    setState(() => isLoading = true);
    final oranges = await _apiService.fetchOranges();
    setState(() {
      availableOranges = oranges;
      if (oranges.isNotEmpty) {
        selectedOrange = oranges[0];
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final measurements = [
      {
        'icon': Icons.straighten,
        'label': 'ความสูง',
        'value': selectedOrange.height,
        'unit': 'ซม.',
        'colors': [Colors.blue.shade500, Colors.blue.shade600],
      },
      {
        'icon': Icons.circle_outlined,
        'label': 'รัศมี',
        'value': selectedOrange.radius,
        'unit': 'ซม.',
        'colors': [Colors.purple.shade500, Colors.purple.shade600],
      },
      {
        'icon': Icons.open_in_full,
        'label': 'เส้นผ่านศูนย์กลาง',
        'value': selectedOrange.diameter,
        'unit': 'ซม.',
        'colors': [Colors.pink.shade500, Colors.pink.shade600],
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Back Button
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, size: 20),
                        padding: EdgeInsets.zero,
                        onPressed: () => widget.onNavigate('home'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'ข้อมูลที่จัดเก็บ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Loading indicator
                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (!isLoading) ...[
                // Orange Type Selector
                const Text(
                  'เลือกชนิดผลส้ม',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: availableOranges.map((orange) {
                    final isSelected = selectedOrange.id == orange.id;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedOrange = orange;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.orange.shade50 : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? Colors.orange.shade500 : const Color(0xFFE2E8F0),
                                width: 2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.orange.withValues(alpha: 0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: orange.colors,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  orange.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF475569),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                
                // Selected Orange Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade50, Colors.amber.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        selectedOrange.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedOrange.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Orange Image Placeholder
                Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.circle,
                      size: 80,
                      color: selectedOrange.colors[0],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Measurements Section
                const Text(
                  'ขนาดและมิติ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 16),
                
                ...measurements.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: item['colors'] as List<Color>,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: (item['colors'] as List<Color>)[0].withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['label'] as String,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '${item['value']}',
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item['unit'] as String,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                
                // Additional Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade50, Colors.amber.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade500,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'หมายเหตุ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ข้อมูลที่แสดงเป็นค่าเฉลี่ยจากการวัด${selectedOrange.name}คุณภาพดีเกรด A+ ที่มีขนาดมาตรฐาน',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
