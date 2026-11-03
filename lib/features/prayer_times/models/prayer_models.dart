import 'package:adhan/adhan.dart';

/// نموذج بيانات المدينة وموقعها الجغرافي.
class CityLocation {
  final String id;
  final String nameAr;
  final String countryAr;
  final double latitude;
  final double longitude;
  final CalculationMethod calculationMethod;

  const CityLocation({
    required this.id,
    required this.nameAr,
    required this.countryAr,
    required this.latitude,
    required this.longitude,
    this.calculationMethod = CalculationMethod.egyptian,
  });

  String get displayName => '$nameAr، $countryAr';
}

/// صنف صلاة مفردة.
class PrayerTimeItem {
  final String key;
  final String name;
  final DateTime time;
  final bool isNext;
  final bool isCurrent;

  const PrayerTimeItem({
    required this.key,
    required this.name,
    required this.time,
    this.isNext = false,
    this.isCurrent = false,
  });

  String get formattedTime {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final h12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$h12:$minute $period';
  }
}

/// حالة يوم كامل لمواقيت الصلاة والقبلة.
class PrayerTimesDay {
  final CityLocation city;
  final List<PrayerTimeItem> prayers;
  final PrayerTimeItem? nextPrayer;
  final Duration? timeUntilNext;
  final double qiblaAngle;
  final DateTime date;

  const PrayerTimesDay({
    required this.city,
    required this.prayers,
    this.nextPrayer,
    this.timeUntilNext,
    required this.qiblaAngle,
    required this.date,
  });
}
