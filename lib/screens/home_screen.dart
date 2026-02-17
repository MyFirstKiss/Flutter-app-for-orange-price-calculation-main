import 'package:flutter/material.dart';
import '../models/orange_type.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                
                // Title
                const Text(
                  'ข้อมูลผลส้ม',
                  style: AppTheme.heading1,
                ),
                const SizedBox(height: 10),
                const Text(
                  'ระบบจัดการข้อมูลและคำนวณราคาผลส้ม',
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyLarge,
                ),
                const SizedBox(height: 36),
                
                // Orange Image
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                    boxShadow: AppTheme.shadowMedium,
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/oranges.png',
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                
                // Info Cards
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          boxShadow: AppTheme.shadowSoft,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${orangeTypes.length}',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'ชนิดผลส้ม',
                              style: TextStyle(fontSize: 15, color: AppTheme.textTertiary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                          boxShadow: AppTheme.shadowSoft,
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'A+',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.accentColor,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'เกรดคุณภาพ',
                              style: TextStyle(fontSize: 15, color: AppTheme.textTertiary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                
                // Menu Buttons
                _buildMenuButton(
                  icon: Icons.bar_chart_rounded,
                  title: 'ข้อมูลที่จัดเก็บ',
                  subtitle: 'ดูขนาดและมิติของผลส้ม',
                  color: AppTheme.primaryColor,
                  onTap: () => onNavigate('data'),
                ),
                const SizedBox(height: 14),
                _buildMenuButton(
                  icon: Icons.calculate_rounded,
                  title: 'คำนวณราคา',
                  subtitle: 'กรอกน้ำหนักเพื่อคำนวณราคา',
                  color: AppTheme.accentColor,
                  onTap: () => onNavigate('calculator'),
                ),
                const SizedBox(height: 14),
                _buildMenuButton(
                  icon: Icons.trending_up_rounded,
                  title: 'ราคาล่าสุด',
                  subtitle: 'ดูราคาแบบ Real-time จาก API',
                  color: const Color(0xFF5B8FB9),
                  onTap: () => onNavigate('liveprices'),
                ),
                const SizedBox(height: 14),
                _buildMenuButton(
                  icon: Icons.history_rounded,
                  title: 'ประวัติการคำนวณ',
                  subtitle: 'ดูประวัติและสถิติการคำนวณราคา',
                  color: const Color(0xFF9B7DB8),
                  onTap: () => onNavigate('history'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
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
                child: Icon(icon, size: 26, color: color),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: AppTheme.textTertiary),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.textTertiary.withValues(alpha: 0.5),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
