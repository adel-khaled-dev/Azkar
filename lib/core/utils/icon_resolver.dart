import 'package:flutter/material.dart';

/// يحوّل اسم أيقونة نصّي (مخزّن في ملفات JSON) إلى `IconData` حقيقي.
/// بهذا تبقى ملفات البيانات نصّية بحتة قابلة للتحرير بسهولة.
IconData resolveIcon(String? name) {
  switch (name) {
    case 'wb_sunny':
      return Icons.wb_sunny_rounded;
    case 'nights_stay':
      return Icons.nights_stay_rounded;
    case 'bedtime':
      return Icons.bedtime_rounded;
    case 'mosque':
      return Icons.mosque_rounded;
    case 'flight':
      return Icons.flight_takeoff_rounded;
    case 'restaurant':
      return Icons.restaurant_rounded;
    case 'home':
      return Icons.home_rounded;
    case 'exit':
      return Icons.logout_rounded;
    case 'checkroom':
      return Icons.checkroom_rounded;
    case 'umbrella':
      return Icons.umbrella_rounded;
    case 'air':
      return Icons.air_rounded;
    case 'thunderstorm':
      return Icons.thunderstorm_rounded;
    case 'healing':
      return Icons.healing_rounded;
    case 'favorite':
      return Icons.favorite_rounded;
    case 'psychology':
      return Icons.psychology_rounded;
    case 'volunteer_activism':
      return Icons.volunteer_activism_rounded;
    case 'auto_stories':
      return Icons.auto_stories_rounded;
    case 'menu_book':
      return Icons.menu_book_rounded;
    case 'format_quote':
      return Icons.format_quote_rounded;
    case 'self_improvement':
      return Icons.self_improvement_rounded;
    case 'shower':
      return Icons.wc_rounded;
    case 'wake':
      return Icons.wb_twilight_rounded;
    case 'palette':
      return Icons.palette_rounded;
    case 'star':
      return Icons.star_rounded;
    case 'shield':
      return Icons.shield_rounded;
    case 'explore':
      return Icons.explore_rounded;
    default:
      return Icons.auto_stories_rounded;
  }
}
