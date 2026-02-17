import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class CommonWidgets {
  // Header with back button
  static Widget buildHeader({
    required String title,
    required VoidCallback onBack,
    Widget? trailing,
  }) {
    return Padding(
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
              onPressed: onBack,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title, style: AppTheme.heading2),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  // Card with warm shadow
  static Widget buildCard({
    required Widget child,
    EdgeInsets? padding,
    double? borderRadius,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius ?? AppTheme.radiusM),
        boxShadow: AppTheme.shadowSoft,
      ),
      child: child,
    );
  }

  // For backward compatibility
  static Widget buildGradientCard({
    required Widget child,
    LinearGradient? gradient,
    EdgeInsets? padding,
    double? borderRadius,
  }) {
    return buildCard(child: child, padding: padding, borderRadius: borderRadius);
  }

  // Loading indicator
  static Widget buildLoadingIndicator({String? text}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          if (text != null) ...[
            const SizedBox(height: 20),
            Text(text, style: AppTheme.bodyMedium),
          ],
        ],
      ),
    );
  }

  // Empty state
  static Widget buildEmptyState({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onRetry,
  }) {
    return Center(
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
            child: Icon(icon, size: 40, color: AppTheme.textTertiary),
          ),
          const SizedBox(height: 20),
          Text(title, style: AppTheme.heading3.copyWith(fontSize: 19)),
          if (subtitle != null) ...[
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('ลองอีกครั้ง'),
              style: AppTheme.primaryButton,
            ),
          ],
        ],
      ),
    );
  }

  // Status badge
  static Widget buildStatusBadge({
    required String text,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Price card
  static Widget buildPriceCard({
    required String label,
    required String price,
    required String unit,
    Color? backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
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
              Text(label, style: AppTheme.bodySmall),
              const SizedBox(height: 6),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(unit, style: AppTheme.bodySmall),
            ],
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            child: const Icon(
              Icons.monetization_on_outlined,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
