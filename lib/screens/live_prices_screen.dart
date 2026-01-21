import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';

class LivePricesScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const LivePricesScreen({super.key, required this.onNavigate});

  @override
  State<LivePricesScreen> createState() => _LivePricesScreenState();
}

class _LivePricesScreenState extends State<LivePricesScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> prices = [];
  bool isLoading = true;
  bool isApiConnected = false;

  @override
  void initState() {
    super.initState();
    _loadPrices();
  }

  Future<void> _loadPrices() async {
    setState(() => isLoading = true);
    
    // ตรวจสอบการเชื่อมต่อ API
    isApiConnected = await _apiService.checkApiStatus();
    
    // ดึงข้อมูลราคา
    final data = await _apiService.fetchLivePrices();
    
    setState(() {
      prices = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            CommonWidgets.buildHeader(
              title: 'ราคาล่าสุด',
              onBack: () => widget.onNavigate('home'),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadPrices,
              ),
            ),

            // API Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL),
              child: CommonWidgets.buildStatusBadge(
                text: isApiConnected ? 'เชื่อมต่อ API สำเร็จ' : 'ใช้ข้อมูลแบบ Offline',
                color: isApiConnected ? AppTheme.successColor : AppTheme.warningColor,
                icon: isApiConnected ? Icons.cloud_done : Icons.cloud_off,
              ),
            ),

            // Price List
            Expanded(
              child: isLoading
                  ? CommonWidgets.buildLoadingIndicator(text: 'กำลังโหลดราคา...')
                  : prices.isEmpty
                      ? CommonWidgets.buildEmptyState(
                          icon: Icons.cloud_off,
                          title: 'ไม่สามารถโหลดข้อมูลได้',
                          subtitle: 'กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต',
                          onRetry: _loadPrices,
                        )
                      : RefreshIndicator(
                          onRefresh: _loadPrices,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(24),
                            itemCount: prices.length,
                            itemBuilder: (context, index) {
                              final price = prices[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
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
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.orange.shade200,
                                              Colors.orange.shade400,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '🍊',
                                            style: TextStyle(fontSize: 24),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              price['name'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF0F172A),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'อัพเดทล่าสุด: ${price['updated_at'] ?? DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString().padLeft(2, '0') + ' น.'}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            if (price['source'] != null) ...[
                                              const SizedBox(height: 2),
                                              Text(
                                                'ที่มา: ${price['source']}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade500,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${price['price']} บาท/กก.',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
