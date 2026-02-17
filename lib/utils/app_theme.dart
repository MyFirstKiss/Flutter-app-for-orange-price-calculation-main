import 'package:flutter/material.dart';

class AppTheme {
  // Colors — Warm Modern Palette
  static const Color primaryColor = Color(0xFFE8723A);
  static const Color primaryDark = Color(0xFFD4612E);
  static const Color primaryLight = Color(0xFFFFF0E6);
  static const Color accentColor = Color(0xFF6B8E5A);
  static const Color accentLight = Color(0xFFEDF4E8);
  
  static const Color backgroundColor = Color(0xFFFFF8F0);
  static const Color cardBackground = Color(0xFFFFFDFB);
  static const Color surfaceColor = Color(0xFFFFF5EC);
  static const Color borderColor = Color(0xFFF0E4D8);
  static const Color dividerColor = Color(0xFFF5EDE4);
  
  static const Color textPrimary = Color(0xFF2D1B0E);
  static const Color textSecondary = Color(0xFF6B5744);
  static const Color textTertiary = Color(0xFF9C8B7A);
  
  static const Color successColor = Color(0xFF6B8E5A);
  static const Color warningColor = Color(0xFFD4A443);
  static const Color errorColor = Color(0xFFCA5B4B);
  
  // Spacing — เพิ่มขนาด
  static const double spacingXS = 6.0;
  static const double spacingS = 10.0;
  static const double spacingM = 16.0;
  static const double spacingL = 20.0;
  static const double spacingXL = 28.0;
  static const double spacingXXL = 40.0;
  
  // Border Radius
  static const double radiusS = 12.0;
  static const double radiusM = 16.0;
  static const double radiusL = 20.0;
  static const double radiusXL = 28.0;
  
  // Font Sizes — เพิ่มทั้งหมด ~2px
  static const double fontSizeXS = 13.0;
  static const double fontSizeS = 14.0;
  static const double fontSizeM = 16.0;
  static const double fontSizeL = 18.0;
  static const double fontSizeXL = 20.0;
  static const double fontSize2XL = 22.0;
  static const double fontSize3XL = 26.0;
  static const double fontSize4XL = 32.0;
  static const double fontSize5XL = 40.0;
  
  // Shadows
  static List<BoxShadow> get shadowSoft => [
    BoxShadow(
      color: const Color(0xFFE8723A).withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: const Color(0xFFE8723A).withValues(alpha: 0.10),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];
  
  // Text Styles — ใหญ่ขึ้น
  static const TextStyle heading1 = TextStyle(
    fontSize: fontSize4XL,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: fontSize3XL,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: fontSize2XL,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSizeL,
    color: textSecondary,
    height: 1.6,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSizeM,
    color: textSecondary,
    height: 1.6,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSizeS,
    color: textTertiary,
    height: 1.5,
  );
  
  static const TextStyle label = TextStyle(
    fontSize: fontSizeM,
    fontWeight: FontWeight.w600,
    color: textSecondary,
  );
  
  // Button Styles
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: spacingL, horizontal: spacingXL),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusM),
    ),
    elevation: 2,
    shadowColor: primaryColor.withValues(alpha: 0.3),
    textStyle: const TextStyle(fontSize: fontSizeL, fontWeight: FontWeight.w600),
  );
  
  static ButtonStyle get secondaryButton => OutlinedButton.styleFrom(
    foregroundColor: textSecondary,
    padding: const EdgeInsets.symmetric(vertical: spacingL, horizontal: spacingXL),
    side: const BorderSide(color: borderColor, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusM),
    ),
    textStyle: const TextStyle(fontSize: fontSizeL, fontWeight: FontWeight.w600),
  );
  
  // Card Decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(radiusM),
    boxShadow: shadowSoft,
  );
  
  // Input Decoration
  static InputDecoration inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: textTertiary, fontSize: fontSizeM),
    filled: true,
    fillColor: cardBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusM),
      borderSide: const BorderSide(color: borderColor, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusM),
      borderSide: const BorderSide(color: borderColor, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusM),
      borderSide: const BorderSide(color: primaryColor, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: spacingL,
      vertical: spacingL,
    ),
  );
}
