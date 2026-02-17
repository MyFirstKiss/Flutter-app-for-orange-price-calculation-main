import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/orange_type.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';
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

  @override
  void initState() {
    super.initState();
    selectedOrange = orangeTypes[0];
    _loadOranges();
  }

  Future<void> _loadOranges() async {
    setState(() => isLoading = true);
    final result = await _apiService.fetchOranges();
    setState(() {
      availableOranges = result.oranges;
      if (result.oranges.isNotEmpty) {
        selectedOrange = result.oranges[0];
      }
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
    if (weight != null && weight > 0) {
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
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to save to Firebase: $e'),
              ),
            );
          }
        }
      } catch (e) {
        // Fallback to local calculation
        setState(() {
          totalPrice = weight * selectedOrange.pricePerKg;
          isCalculating = false;
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero gradient banner ──────────────────────────
            _buildHero(),
            // ── Content ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLoading)
                    Center(
                      child: Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF4E8),
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Color(0xFF6B8E5A)),
                        ),
                      ),
                    )
                  else ...[
                // ── Orange type selector ─────────────────────
                    const Text('Select Orange Type', style: AppTheme.label),
                    const SizedBox(height: 14),
                    ...availableOranges.map((orange) {
                      final isSelected = selectedOrange.id == orange.id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            selectedOrange = orange;
                            totalPrice = null;
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFEDF4E8)
                                  : AppTheme.cardBackground,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusM),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF6B8E5A)
                                    : AppTheme.borderColor,
                                width: isSelected ? 1.5 : 1,
                              ),
                              boxShadow: AppTheme.shadowSoft,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: orange.colors,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/${orange.id}.png',
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const SizedBox(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(orange.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                            color: AppTheme.textPrimary,
                                          )),
                                      const SizedBox(height: 2),
                                      Text('${orange.pricePerKg} THB/kg',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.textTertiary)),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF6B8E5A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check,
                                        color: Colors.white, size: 16),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),

                    // ── Price info card ───────────────────────
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6B8E5A), Color(0xFF8FB876)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusL),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6B8E5A)
                                .withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -16,
                            bottom: -16,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text('Price per kg',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white
                                              .withValues(alpha: 0.8))),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${selectedOrange.pricePerKg} THB',
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withValues(alpha: 0.2),
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.attach_money,
                                    color: Colors.white, size: 28),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Weight input ──────────────────────────
                    const Text('Enter Weight (kg)', style: AppTheme.label),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusM),
                        border: Border.all(
                            color: AppTheme.borderColor, width: 1.5),
                        boxShadow: AppTheme.shadowSoft,
                      ),
                      child: TextField(
                        controller: weightController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary),
                        onTap: () {
                          // clear on focus if 0
                        },
                        decoration: const InputDecoration(
                          hintText: '0.00',
                          hintStyle: TextStyle(
                              color: AppTheme.textTertiary, fontSize: 26),
                          suffixText: 'kg',
                          suffixStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textTertiary),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Action buttons ────────────────────────
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ElevatedButton(
                            onPressed: isCalculating ? null : handleCalculate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6B8E5A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.radiusM)),
                              elevation: 3,
                              shadowColor: const Color(0xFF6B8E5A)
                                  .withValues(alpha: 0.4),
                            ),
                            child: isCalculating
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2))
                                : const Text('Calculate',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: OutlinedButton(
                            onPressed: handleClear,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.textSecondary,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16),
                              side: const BorderSide(
                                  color: AppTheme.borderColor, width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.radiusM)),
                            ),
                            child: const Text('Clear',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),

                    // ── Result card ───────────────────────────
                    if (totalPrice != null) ...[
                      const SizedBox(height: 24),
                      AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFF0E6),
                                Color(0xFFFFF8ED)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusL),
                            border: Border.all(
                                color: AppTheme.primaryColor
                                    .withValues(alpha: 0.2)),
                            boxShadow: AppTheme.shadowMedium,
                          ),
                          child: Column(
                            children: [
                              const Text('Total Price',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textTertiary)),
                              const SizedBox(height: 8),
                              Text(
                                totalPrice!.toStringAsFixed(2),
                                style: const TextStyle(
                                    fontSize: 52,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primaryColor,
                                    letterSpacing: -1),
                              ),
                              const Text('THB',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppTheme.textSecondary,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 20),
                              Container(
                                  height: 1,
                                  color: AppTheme.dividerColor),
                              const SizedBox(height: 16),
                              _buildDetailRow(
                                  'Type', selectedOrange.name),
                              const SizedBox(height: 8),
                              _buildDetailRow('Weight',
                                  '${weightController.text} kg'),
                              const SizedBox(height: 8),
                              _buildDetailRow('Price/kg',
                                  '${selectedOrange.pricePerKg} THB'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Green gradient hero (matches home "Calculate" card) ───────────────
  Widget _buildHero() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6B8E5A), Color(0xFF8FB876), Color(0xFFB5D99C)],
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
        child: Stack(
          children: [
            Positioned(
              right: -24,
              bottom: -24,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 70,
              top: -20,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => widget.onNavigate('home'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Price Calculator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Select variety · enter weight',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, color: AppTheme.textTertiary)),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary)),
      ],
    );
  }
}

