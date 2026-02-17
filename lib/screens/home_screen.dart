import 'package:flutter/material.dart';
import '../models/orange_type.dart';

class HomeScreen extends StatelessWidget {
  final Function(String) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero gradient banner ──────────────────────────
            _buildHero(),

            // ── Stats row ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  _buildStatCard('${orangeTypes.length}', 'ชนิดผลส้ม',
                      Icons.emoji_nature_rounded,
                      const Color(0xFFE8723A), const Color(0xFFFFEEE3)),
                  const SizedBox(width: 12),
                  _buildStatCard('A+', 'คุณภาพ',
                      Icons.workspace_premium_rounded,
                      const Color(0xFF6B8E5A), const Color(0xFFEBF5E4)),
                  const SizedBox(width: 12),
                  _buildStatCard('Live', 'ราคา',
                      Icons.bolt_rounded,
                      const Color(0xFF5B8FB9), const Color(0xFFE4F0FB)),
                ],
              ),
            ),

            // ── Section label ────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 14),
              child: Text('เมนูหลัก',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D1B0E),
                  )),
            ),

            // ── 2×2 Grid menu ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildGridCard(
                          icon: Icons.bar_chart_rounded,
                          title: 'ข้อมูลส้ม',
                          subtitle: 'ขนาดและมิติ',
                          gradientColors: const [Color(0xFFE8723A), Color(0xFFFF9A5C)],
                          onTap: () => onNavigate('data'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildGridCard(
                          icon: Icons.calculate_rounded,
                          title: 'คำนวณราคา',
                          subtitle: 'กรอกน้ำหนัก',
                          gradientColors: const [Color(0xFF6B8E5A), Color(0xFF8FB876)],
                          onTap: () => onNavigate('calculator'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGridCard(
                          icon: Icons.trending_up_rounded,
                          title: 'ราคาล่าสุด',
                          subtitle: 'Real-time API',
                          gradientColors: const [Color(0xFF5B8FB9), Color(0xFF7DB8E8)],
                          onTap: () => onNavigate('liveprices'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildGridCard(
                          icon: Icons.history_rounded,
                          title: 'ประวัติ',
                          subtitle: 'การคำนวณ',
                          gradientColors: const [Color(0xFF9B7DB8), Color(0xFFBFA3D9)],
                          onTap: () => onNavigate('history'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Hero ─────────────────────────────────────────────────
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('🍊  Orange Calc',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 14),
                    const Text('ข้อมูลผลส้ม',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        )),
                    const SizedBox(height: 6),
                    Text('คำนวณราคาและติดตาม\nราคาแบบ Real-time',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 15,
                          height: 1.5,
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Orange image with glowing circle
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4612E).withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ClipOval(
                    child: Image.asset('assets/oranges.png', fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Stat card ────────────────────────────────────────────
  Widget _buildStatCard(String value, String label, IconData icon,
      Color color, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9C8B7A),
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // ── Grid menu card ───────────────────────────────────────
  Widget _buildGridCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // decorative circle
            Positioned(
              right: -16,
              bottom: -16,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: -20,
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // content
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )),
                      Text(subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          )),
                    ],
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
