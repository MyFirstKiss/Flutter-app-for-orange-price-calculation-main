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
    if (!mounted) return;
    setState(() => isLoading = true);
    
    isApiConnected = await _apiService.checkApiStatus();
    final data = await _apiService.fetchLivePrices();
    
    if (!mounted) return;
    setState(() {
      prices = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            CommonWidgets.buildHeader(
              title: 'Live Prices',
              onBack: () => widget.onNavigate('home'),
              trailing: Container(
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
                  onPressed: _loadPrices,
                ),
              ),
            ),

            // Status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: CommonWidgets.buildStatusBadge(
                text: isApiConnected ? 'API Connected' : 'Offline Mode',
                color: isApiConnected ? AppTheme.accentColor : AppTheme.warningColor,
                icon: isApiConnected ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
              ),
            ),
            const SizedBox(height: 16),

            // Price List
            Expanded(
              child: isLoading
                  ? CommonWidgets.buildLoadingIndicator(text: 'Loading prices...')
                  : prices.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadPrices,
                          color: AppTheme.primaryColor,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
                            itemCount: prices.length,
                            itemBuilder: (context, index) {
                              final price = prices[index];
                              return _buildPriceItem(price);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cloud_off_rounded, size: 44, color: AppTheme.textTertiary),
            ),
            const SizedBox(height: 24),
            const Text(
              'Unable to load data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Check your API connection\nand make sure Backend is running.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppTheme.textTertiary, height: 1.6),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _loadPrices,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Try Again'),
              style: AppTheme.primaryButton,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceItem(Map<String, dynamic> price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
                'assets/${price['id'] ?? 'oranges'}.png',
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
                    price['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Updated: ${price['updated_at'] ?? '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}'}',
                    style: const TextStyle(fontSize: 14, color: AppTheme.textTertiary),
                  ),
                  if (price['source'] != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      'Source: ${price['source']}',
                      style: const TextStyle(fontSize: 13, color: AppTheme.textTertiary, fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
            ),
            // Price
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
              child: Text(
                '${price['price']} ฿',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
