import 'package:flutter/material.dart';
import '../models/orange_type.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';

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
        if (result.oranges.isNotEmpty) {
          selectedOrange = result.oranges[0];
        }
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final measurements = [
      {
        'icon': Icons.straighten_rounded,
        'label': 'ความสูง',
        'value': selectedOrange.height,
        'unit': 'ซม.',
        'color': AppTheme.primaryColor,
      },
      {
        'icon': Icons.circle_outlined,
        'label': 'รัศมี',
        'value': selectedOrange.radius,
        'unit': 'ซม.',
        'color': const Color(0xFF9B7DB8),
      },
      {
        'icon': Icons.open_in_full_rounded,
        'label': 'เส้นผ่านศูนย์กลาง',
        'value': selectedOrange.diameter,
        'unit': 'ซม.',
        'color': const Color(0xFF5B8FB9),
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        shape: BoxShape.circle,
                        boxShadow: AppTheme.shadowSoft,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, size: 22, color: AppTheme.textPrimary),
                        padding: EdgeInsets.zero,
                        onPressed: () => widget.onNavigate('home'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text('ข้อมูลที่จัดเก็บ', style: AppTheme.heading2),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                if (isLoading)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: AppTheme.primaryColor),
                        ),
                      ),
                    ),
                  ),
                if (!isLoading) ...[
                // Orange Selector
                const Text('เลือกชนิดผลส้ม', style: AppTheme.label),
                const SizedBox(height: 16),
                Row(
                  children: availableOranges.map((orange) {
                    final isSelected = selectedOrange.id == orange.id;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedOrange = orange;
                            });
                          },
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primaryLight : AppTheme.cardBackground,
                              borderRadius: BorderRadius.circular(AppTheme.radiusM),
                              border: isSelected ? Border.all(
                                color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                width: 1.5,
                              ) : null,
                              boxShadow: AppTheme.shadowSoft,
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/${orange.id}.png',
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: AppTheme.surfaceColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  orange.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? AppTheme.textPrimary : AppTheme.textTertiary,
                                    height: 1.3,
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
                const SizedBox(height: 32),
                
                // Orange Image
                Center(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                      boxShadow: AppTheme.shadowMedium,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                      child: Image.asset(
                        'assets/${selectedOrange.id}.png',
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.circle,
                            size: 80,
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Name & Grade
                Center(
                  child: Column(
                    children: [
                      Text(
                        selectedOrange.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.accentLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'คุณภาพ A+',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                
                // Measurements
                const Text('ขนาดและมิติ', style: AppTheme.label),
                const SizedBox(height: 16),
                
                ...measurements.map((item) {
                  final color = item['color'] as Color;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        boxShadow: AppTheme.shadowSoft,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppTheme.radiusS),
                            ),
                            child: Icon(item['icon'] as IconData, color: color, size: 24),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Text(
                              item['label'] as String,
                              style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${item['value']}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                item['unit'] as String,
                                style: const TextStyle(fontSize: 15, color: AppTheme.textTertiary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                
                const SizedBox(height: 10),
                // Note
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: AppTheme.primaryColor.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'ข้อมูลที่แสดงเป็นค่าเฉลี่ยจากการวัด${selectedOrange.name}คุณภาพดีเกรด A+ ที่มีขนาดมาตรฐาน',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textTertiary,
                            height: 1.6,
                          ),
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
