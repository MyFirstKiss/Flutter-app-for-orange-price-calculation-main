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
        'label': 'Height',
        'value': selectedOrange.height,
        'unit': 'cm',
        'color': AppTheme.primaryColor,
      },
      {
        'icon': Icons.circle_outlined,
        'label': 'Radius',
        'value': selectedOrange.radius,
        'unit': 'cm',
        'color': const Color(0xFF9B7DB8),
      },
      {
        'icon': Icons.open_in_full_rounded,
        'label': 'Diameter',
        'value': selectedOrange.diameter,
        'unit': 'cm',
        'color': const Color(0xFF5B8FB9),
      },
    ];

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
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppTheme.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  if (!isLoading) ...[
                    // ── Variety selector ─────────────────────
                    const Text('Select Variety', style: AppTheme.label),
                    const SizedBox(height: 16),
                    Row(
                      children: availableOranges.map((orange) {
                        final isSelected = selectedOrange.id == orange.id;
                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => selectedOrange = orange),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.primaryLight
                                      : AppTheme.cardBackground,
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.radiusM),
                                  border: isSelected
                                      ? Border.all(
                                          color: AppTheme.primaryColor
                                              .withValues(alpha: 0.35),
                                          width: 1.5)
                                      : null,
                                  boxShadow: AppTheme.shadowSoft,
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/${orange.id}.png',
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: AppTheme.surfaceColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      orange.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? AppTheme.textPrimary
                                            : AppTheme.textTertiary,
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

                    // ── Orange image ──────────────────────────
                    Center(
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusXL),
                          boxShadow: AppTheme.shadowMedium,
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusXL),
                          child: Image.asset(
                            'assets/${selectedOrange.id}.png',
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.circle,
                                    size: 80,
                                    color: AppTheme.primaryColor
                                        .withValues(alpha: 0.3)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Name & grade ──────────────────────────
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.accentLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Grade A+',
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

                    // ── Measurements ──────────────────────────
                    const Text('Size & Dimensions', style: AppTheme.label),
                    const SizedBox(height: 16),
                    ...measurements.map((item) {
                      final color = item['color'] as Color;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: AppTheme.cardDecoration,
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.radiusS),
                                ),
                                child: Icon(item['icon'] as IconData,
                                    color: color, size: 24),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Text(
                                  item['label'] as String,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.textSecondary),
                                ),
                              ),
                              Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.baseline,
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
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: AppTheme.textTertiary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),

                    // ── Note ──────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusM),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 20,
                              color: AppTheme.primaryColor
                                  .withValues(alpha: 0.6)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Measurements shown are averages from grade A+ ${selectedOrange.name} of standard size.',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textTertiary,
                                  height: 1.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Orange gradient hero (matches home "Orange Data" card) ────────────
  Widget _buildHero() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE8723A), Color(0xFFFF9A5C), Color(0xFFFFBD7A)],
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
              right: 60,
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
                    'Orange Data',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Variety info & dimensions',
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
}
