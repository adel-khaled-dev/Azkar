import 'package:flutter/material.dart';

/// لوحة الألوان الموحّدة للتطبيق — هوية إسلامية راقية (أخضر زمردي + ذهبي).
abstract final class AppColors {
  // الهوية الأساسية
  static const Color primary = Color(0xFF0E7A5F);
  static const Color primaryDeep = Color(0xFF074837);
  static const Color primarySoft = Color(0xFFE2F1EB);
  static const Color primaryDarkSoft = Color(0xFF163229);
  static const Color gold = Color(0xFFC9973B);
  static const Color goldSoft = Color(0xFFF6EEDB);
  static const Color goldDarkSoft = Color(0xFF332712);

  // ألوان إضافية للفئات
  static const Color blue = Color(0xFF3E65FF);
  static const Color blueSoft = Color(0xFFEAF0FF);
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberSoft = Color(0xFFFEF3C7);
  static const Color rose = Color(0xFFE11D48);
  static const Color roseSoft = Color(0xFFFFE4E6);
  static const Color teal = Color(0xFF0D9488);
  static const Color tealSoft = Color(0xFFCCFBF1);
  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleSoft = Color(0xFFEDE9FE);

  // الوضع الفاتح
  static const Color backgroundLight = Color(0xFFF7F6F2);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textLight = Color(0xFF14241E);
  static const Color textMutedLight = Color(0xFF53675E);
  static const Color dividerLight = Color(0xFFE5E3DB);
  static const Color cardBorderLight = Color(0xFFE8E5DD);

  // الوضع الداكن (مُحسّن للتباين العالي والراحة البصرية)
  static const Color backgroundDark = Color(0xFF090D0B);
  static const Color surfaceDark = Color(0xFF131A16);
  static const Color surfaceDarkHighlight = Color(0xFF1A2420);
  static const Color textDark = Color(0xFFF2F7F4);
  static const Color textMutedDark = Color(0xFF98ACA2);
  static const Color dividerDark = Color(0xFF1E2822);
  static const Color cardBorderDark = Color(0xFF223029);
}

/// الثيم الموحّد (فاتح / داكن) — مُخزّن مسبقاً (Pre-built) لضمان سرعة التبديل الفورية دون أي تهنيج.
abstract final class AppTheme {
  static final ThemeData light = _buildTheme(isDark: false);
  static final ThemeData dark = _buildTheme(isDark: true);

  static ThemeData _buildTheme({required bool isDark}) {
    final Color background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final Color surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final Color text = isDark ? AppColors.textDark : AppColors.textLight;
    final Color muted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final Color divider = isDark ? AppColors.dividerDark : AppColors.dividerLight;
    final Color border = isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight;

    final colorScheme = ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: isDark ? const Color(0xFF149E7C) : AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: isDark ? AppColors.primaryDarkSoft : AppColors.primarySoft,
      onPrimaryContainer: isDark ? const Color(0xFF82E3C6) : AppColors.primaryDeep,
      secondary: AppColors.gold,
      onSecondary: Colors.black,
      secondaryContainer: isDark ? AppColors.goldDarkSoft : AppColors.goldSoft,
      onSecondaryContainer: isDark ? const Color(0xFFF0D597) : const Color(0xFF6B4E15),
      surface: surface,
      onSurface: text,
      onSurfaceVariant: muted,
      outline: border,
      outlineVariant: divider,
      error: const Color(0xFFBA1A1A),
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      canvasColor: surface,
      cardColor: surface,
      dividerColor: divider,
      textTheme: const TextTheme().apply(
        bodyColor: text,
        displayColor: text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: text),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: border, width: 1),
        ),
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 1, space: 1),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: isDark ? AppColors.primaryDarkSoft : AppColors.primarySoft,
        height: 70,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? (isDark ? const Color(0xFF26C49B) : AppColors.primary)
                : muted,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? (isDark ? const Color(0xFF26C49B) : AppColors.primary)
                : muted,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppColors.surfaceDarkHighlight : AppColors.textLight,
        contentTextStyle: TextStyle(
          color: isDark ? AppColors.textDark : AppColors.surfaceLight,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? (isDark ? const Color(0xFF26C49B) : AppColors.primary)
              : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? (isDark ? AppColors.primaryDarkSoft : AppColors.primarySoft)
              : null,
        ),
      ),
    );
  }
}
