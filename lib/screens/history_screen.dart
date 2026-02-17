import 'package:flutter/material.dart';
import '../models/price_calculation.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final Function(String) onNavigate;
  
  const HistoryScreen({super.key, required this.onNavigate});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiService _apiService = ApiService();
  List<PriceCalculation> _calculations = [];
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final calculations = await _apiService.fetchCalculations(limit: 100);
      final stats = await _apiService.fetchStatistics();
      
      if (!mounted) return;
      setState(() {
        _calculations = calculations;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'ไม่สามารถโหลดข้อมูลได้: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCalculation(PriceCalculation calc) async {
    final int originalIndex = _calculations.indexOf(calc);
    
    if (!mounted) return;
    setState(() {
      _calculations.remove(calc);
    });

    final snackBar = SnackBar(
      content: Text('ลบ ${calc.orangeName} สำเร็จ', style: const TextStyle(fontSize: 15)),
      backgroundColor: AppTheme.textPrimary,
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(20),
      action: SnackBarAction(
        label: 'เลิกทำ',
        textColor: AppTheme.primaryColor,
        onPressed: () {
          if (!mounted) return;
          setState(() {
            _calculations.insert(originalIndex, calc);
          });
        },
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    
    Future.delayed(const Duration(seconds: 1), () async {
      if (mounted && !_calculations.contains(calc)) {
        try {
          await _apiService.deleteCalculation(calc.id);
        } catch (e) {
          debugPrint('❌ เกิดข้อผิดพลาดในการลบ: $e');
        }
      }
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'วันนี้ ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return 'เมื่อวาน ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} วันที่แล้ว';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Row(
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
                  const Expanded(
                    child: Text('ประวัติการคำนวณ', style: AppTheme.heading2),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.cardBackground,
                      shape: BoxShape.circle,
                      boxShadow: AppTheme.shadowSoft,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.refresh_rounded, size: 20, color: AppTheme.textSecondary),
                      padding: EdgeInsets.zero,
                      onPressed: _loadData,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: _isLoading
                  ? Center(
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
                    )
                  : _error != null
                      ? _buildErrorState()
                      : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_outline_rounded, size: 36, color: AppTheme.textTertiary),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _error!,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadData,
            style: AppTheme.primaryButton,
            child: const Text('ลองอีกครั้ง'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Stats
        if (_stats != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                boxShadow: AppTheme.shadowSoft,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.calculate_rounded,
                    label: 'ทั้งหมด',
                    value: '${_stats!['total_calculations'] ?? 0}',
                    color: AppTheme.primaryColor,
                  ),
                  Container(height: 44, width: 1, color: AppTheme.dividerColor),
                  _buildStatItem(
                    icon: Icons.star_rounded,
                    label: 'ยอดนิยม',
                    value: _stats!['most_popular_count']?.toString() ?? '0',
                    color: AppTheme.warningColor,
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),

        // List
        Expanded(
          child: _calculations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.history_rounded, size: 40, color: AppTheme.textTertiary),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'ยังไม่มีประวัติการคำนวณ',
                        style: TextStyle(fontSize: 17, color: AppTheme.textTertiary),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                  itemCount: _calculations.length,
                  itemBuilder: (context, index) {
                    return _buildHistoryCard(_calculations[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppTheme.textTertiary, fontSize: 15)),
      ],
    );
  }

  Widget _buildHistoryCard(PriceCalculation calc) {
    return Dismissible(
      key: Key(calc.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppTheme.errorColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 28),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
              ),
              backgroundColor: AppTheme.cardBackground,
              title: const Text(
                'ยืนยันการลบ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
              content: Text(
                'คุณต้องการลบประวัติ "${calc.orangeName}" หรือไม่?',
                style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('ยกเลิก', style: TextStyle(color: AppTheme.textTertiary, fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusS)),
                  ),
                  child: const Text('ลบ', style: TextStyle(fontSize: 16)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        _deleteCalculation(calc);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            onTap: () => _showDetailsDialog(calc),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: AppTheme.shadowSoft,
              ),
              child: Row(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    child: Image.asset(
                      'assets/${calc.orangeType}.png',
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(AppTheme.radiusS),
                          ),
                          child: const Icon(Icons.circle, color: AppTheme.primaryColor, size: 26),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          calc.orangeName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${calc.weightKg.toStringAsFixed(2)} กก. × ${calc.pricePerKg.toStringAsFixed(0)} ฿/กก.',
                          style: const TextStyle(fontSize: 14, color: AppTheme.textTertiary),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _formatDate(calc.date),
                          style: const TextStyle(fontSize: 13, color: AppTheme.textTertiary),
                        ),
                      ],
                    ),
                  ),
                  
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '฿${calc.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Icon(Icons.chevron_right_rounded, color: AppTheme.textTertiary, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(PriceCalculation calc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusL)),
        backgroundColor: AppTheme.cardBackground,
        title: Text(
          calc.orangeName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('น้ำหนัก', '${calc.weightKg.toStringAsFixed(2)} กก.'),
            Divider(color: AppTheme.dividerColor, height: 28),
            _buildDetailRow('ราคาต่อกก.', '฿${calc.pricePerKg.toStringAsFixed(2)}'),
            Divider(color: AppTheme.dividerColor, height: 28),
            _buildDetailRow('ราคารวม', '฿${calc.totalPrice.toStringAsFixed(2)}', isTotal: true),
            Divider(color: AppTheme.dividerColor, height: 28),
            _buildDetailRow('วันที่', DateFormat('dd/MM/yyyy HH:mm').format(calc.date)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 17 : 16,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: AppTheme.textTertiary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal ? AppTheme.primaryColor : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
