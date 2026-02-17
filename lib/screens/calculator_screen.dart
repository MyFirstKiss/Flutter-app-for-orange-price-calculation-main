import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/orange_type.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';

class CalculatorScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const CalculatorScreen({super.key, required this.onNavigate});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final ApiService _apiService = ApiService();
  late OrangeType selectedOrange;
  List<OrangeType> availableOranges = orangeTypes;
  final TextEditingController weightController = TextEditingController();
  double? totalPrice;
  bool isLoading = true;
  bool isCalculating = false;
  bool isOnline = true;
  bool isUsingLocalData = false;

  @override
  void initState() {
    super.initState();
    selectedOrange = orangeTypes[0];
    _loadOranges();
  }

  Future<void> _loadOranges() async {
    setState(() {
      isLoading = true;
      isOnline = true;
      isUsingLocalData = false;
    });
    
    try {
      final result = await _apiService.fetchOranges();
      if (!mounted) return;
      
      setState(() {
        availableOranges = result.oranges;
        if (result.oranges.isNotEmpty) {
          selectedOrange = result.oranges[0];
        }
        isOnline = result.isFromApi;
        isUsingLocalData = !result.isFromApi;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      debugPrint('❌ Error: $e');
      setState(() {
        availableOranges = orangeTypes;
        selectedOrange = orangeTypes[0];
        isUsingLocalData = true;
        isOnline = false;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  Future<void> handleCalculate() async {
    final weight = double.tryParse(weightController.text);
    if (weight != null && weight > 0) {
      setState(() => isCalculating = true);
      
      try {
        final result = await _apiService.calculatePrice(selectedOrange.id, weight);
        if (!mounted) return;
        
        if (result.isFromApi && result.result != null) {
          setState(() {
            totalPrice = result.result!['total_price'];
            isCalculating = false;
            isUsingLocalData = false;
          });
        } else {
          setState(() {
            totalPrice = weight * selectedOrange.pricePerKg;
            isCalculating = false;
            isUsingLocalData = true;
          });
        }
      } catch (e) {
        if (!mounted) return;
        debugPrint('❌ Error: $e');
        setState(() {
          totalPrice = weight * selectedOrange.pricePerKg;
          isCalculating = false;
          isUsingLocalData = true;
        });
      }
    }
  }

  void handleClear() {
    setState(() {
      weightController.clear();
      totalPrice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
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
                    const SizedBox(width: 14),
                    const Text('คำนวณราคา', style: AppTheme.heading2),
                  ],
                ),
                const SizedBox(height: 28),
                
                // Status
                if (!isLoading)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUsingLocalData
                          ? AppTheme.warningColor.withValues(alpha: 0.1)
                          : AppTheme.accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isUsingLocalData ? Icons.cloud_off_rounded : Icons.cloud_done_rounded,
                          size: 16,
                          color: isUsingLocalData ? AppTheme.warningColor : AppTheme.accentColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isUsingLocalData ? 'ใช้ข้อมูลเริ่มต้น (ออฟไลน์)' : 'เชื่อมต่อ API สำเร็จ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isUsingLocalData ? AppTheme.warningColor : AppTheme.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                
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
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  )
                else ...[
                // Orange Type Selector
                const Text('เลือกชนิดผลส้ม', style: AppTheme.label),
                const SizedBox(height: 14),
                
                ...availableOranges.map((orange) {
                  final isSelected = selectedOrange.id == orange.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedOrange = orange;
                          totalPrice = null;
                        });
                      },
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryLight : AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.4) : Colors.transparent,
                            width: 1.5,
                          ),
                          boxShadow: AppTheme.shadowSoft,
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppTheme.radiusS),
                              child: Image.asset(
                                'assets/${orange.id}.png',
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceColor,
                                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                                    ),
                                    child: const Icon(Icons.circle, size: 24, color: AppTheme.primaryColor),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    orange.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${orange.pricePerKg} บาท/กก.',
                                    style: const TextStyle(fontSize: 15, color: AppTheme.textTertiary),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 28),
                
                // Price Info Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    boxShadow: AppTheme.shadowSoft,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ราคาต่อกิโลกรัม',
                            style: TextStyle(fontSize: 15, color: AppTheme.textTertiary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${selectedOrange.pricePerKg} บาท',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppTheme.radiusS),
                        ),
                        child: const Icon(Icons.sell_rounded, color: AppTheme.primaryColor, size: 28),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                
                // Weight Input
                const Text('น้ำหนัก (กิโลกรัม)', style: AppTheme.label),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    boxShadow: AppTheme.shadowSoft,
                  ),
                  child: TextField(
                    controller: weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle: TextStyle(color: AppTheme.textTertiary.withValues(alpha: 0.5), fontSize: 28),
                      suffixText: 'กก.',
                      suffixStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textTertiary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                
                // Buttons
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: isCalculating ? null : handleCalculate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          ),
                          elevation: 2,
                          shadowColor: AppTheme.primaryColor.withValues(alpha: 0.3),
                        ),
                        child: isCalculating
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('คำนวณ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: handleClear,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textSecondary,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: const BorderSide(color: AppTheme.borderColor, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          ),
                        ),
                        child: const Text('ล้าง', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
                
                // Result Card
                if (totalPrice != null) ...[
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground,
                      borderRadius: BorderRadius.circular(AppTheme.radiusL),
                      boxShadow: AppTheme.shadowMedium,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'ราคารวมทั้งหมด',
                          style: TextStyle(fontSize: 15, color: AppTheme.textTertiary),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          totalPrice!.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const Text(
                          'บาท',
                          style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 24),
                        Container(height: 1, color: AppTheme.dividerColor),
                        const SizedBox(height: 20),
                        _buildDetailRow('ชนิด:', selectedOrange.name),
                        const SizedBox(height: 12),
                        _buildDetailRow('น้ำหนัก:', '${weightController.text} กก.'),
                        const SizedBox(height: 12),
                        _buildDetailRow('ราคา/กก.:', '${selectedOrange.pricePerKg} บาท'),
                      ],
                    ),
                  ),
                ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: AppTheme.textTertiary)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
        ),
      ],
    );
  }
}
