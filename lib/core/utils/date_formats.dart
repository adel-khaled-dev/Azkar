import 'package:hijri/hijri_calendar.dart';

/// تنسيق التواريخ (هجري / ميلادي) بالعربية.
abstract final class AppDates {
  static String get hijriFull {
    HijriCalendar.language = 'ar';
    return HijriCalendar.now().toFormat('dd MMMM yyyy');
  }

  static String get gregorianFull {
    final now = DateTime.now();
    const weekdays = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${weekdays[now.weekday - 1]}، ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  /// تحية حسب وقت اليوم.
  static String get greeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'صباح الخير';
    if (hour >= 12 && hour < 17) return 'طاب يومك';
    if (hour >= 17 && hour < 21) return 'مساء الخير';
    return 'مساء النور';
  }
}
