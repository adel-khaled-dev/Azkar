import 'package:adhan/adhan.dart';
import 'package:azkar/features/prayer_times/models/prayer_models.dart';

/// مستودع حساب مواقيت الصلاة وقاعدة بيانات المدن.
class PrayerRepository {
  const PrayerRepository();

  static const List<CityLocation> defaultCities = [
    // محافظات ومدن مصر (الافتراضية)
    CityLocation(
      id: 'cairo',
      nameAr: 'القاهرة',
      countryAr: 'مصر',
      latitude: 30.0444,
      longitude: 31.2357,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'alexandria',
      nameAr: 'الإسكندرية',
      countryAr: 'مصر',
      latitude: 31.2001,
      longitude: 29.9187,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'giza',
      nameAr: 'الجيزة',
      countryAr: 'مصر',
      latitude: 30.0131,
      longitude: 31.2089,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'mansoura',
      nameAr: 'المنصورة',
      countryAr: 'مصر',
      latitude: 31.0409,
      longitude: 31.3785,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'tanta',
      nameAr: 'طنطا',
      countryAr: 'مصر',
      latitude: 30.7865,
      longitude: 31.0004,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'zagazig',
      nameAr: 'الزقازيق',
      countryAr: 'مصر',
      latitude: 30.5877,
      longitude: 31.5020,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'portsaid',
      nameAr: 'بورسعيد',
      countryAr: 'مصر',
      latitude: 31.2653,
      longitude: 32.3019,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'suez',
      nameAr: 'السويس',
      countryAr: 'مصر',
      latitude: 29.9668,
      longitude: 32.5498,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'ismailia',
      nameAr: 'الإسماعيلية',
      countryAr: 'مصر',
      latitude: 30.5965,
      longitude: 32.2715,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'asyut',
      nameAr: 'أسيوط',
      countryAr: 'مصر',
      latitude: 27.1783,
      longitude: 31.1859,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'sohag',
      nameAr: 'سوهاج',
      countryAr: 'مصر',
      latitude: 26.5590,
      longitude: 31.6957,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'qena',
      nameAr: 'قنا',
      countryAr: 'مصر',
      latitude: 26.1551,
      longitude: 32.7160,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'luxor',
      nameAr: 'الأقصر',
      countryAr: 'مصر',
      latitude: 25.6872,
      longitude: 32.6396,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'aswan',
      nameAr: 'أسوان',
      countryAr: 'مصر',
      latitude: 24.0889,
      longitude: 32.8998,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'hurghada',
      nameAr: 'الغردقة',
      countryAr: 'مصر',
      latitude: 27.2579,
      longitude: 33.8116,
      calculationMethod: CalculationMethod.egyptian,
    ),
    CityLocation(
      id: 'sharm',
      nameAr: 'شرم الشيخ',
      countryAr: 'مصر',
      latitude: 27.9158,
      longitude: 34.3299,
      calculationMethod: CalculationMethod.egyptian,
    ),

    // المملكة العربية السعودية
    CityLocation(
      id: 'makkah',
      nameAr: 'مكة المكرمة',
      countryAr: 'السعودية',
      latitude: 21.4225,
      longitude: 39.8262,
      calculationMethod: CalculationMethod.umm_al_qura,
    ),
    CityLocation(
      id: 'madinah',
      nameAr: 'المدينة المنورة',
      countryAr: 'السعودية',
      latitude: 24.5247,
      longitude: 39.5692,
      calculationMethod: CalculationMethod.umm_al_qura,
    ),
    CityLocation(
      id: 'riyadh',
      nameAr: 'الرياض',
      countryAr: 'السعودية',
      latitude: 24.7136,
      longitude: 46.6753,
      calculationMethod: CalculationMethod.umm_al_qura,
    ),
    CityLocation(
      id: 'jeddah',
      nameAr: 'جدة',
      countryAr: 'السعودية',
      latitude: 21.4858,
      longitude: 39.1925,
      calculationMethod: CalculationMethod.umm_al_qura,
    ),

    // الإمارات العربية المتحدة
    CityLocation(
      id: 'dubai',
      nameAr: 'دبي',
      countryAr: 'الإمارات',
      latitude: 25.2048,
      longitude: 55.2708,
      calculationMethod: CalculationMethod.dubai,
    ),
    CityLocation(
      id: 'abudhabi',
      nameAr: 'أبوظبي',
      countryAr: 'الإمارات',
      latitude: 24.4539,
      longitude: 54.3773,
      calculationMethod: CalculationMethod.dubai,
    ),

    // عواصم عربية وإسلامية
    CityLocation(
      id: 'kuwait',
      nameAr: 'الكويت',
      countryAr: 'الكويت',
      latitude: 29.3759,
      longitude: 47.9774,
      calculationMethod: CalculationMethod.kuwait,
    ),
    CityLocation(
      id: 'doha',
      nameAr: 'الدوحة',
      countryAr: 'قطر',
      latitude: 25.2854,
      longitude: 51.5310,
      calculationMethod: CalculationMethod.qatar,
    ),
    CityLocation(
      id: 'jerusalem',
      nameAr: 'القدس الشريف',
      countryAr: 'فلسطين',
      latitude: 31.7683,
      longitude: 35.2137,
      calculationMethod: CalculationMethod.muslim_world_league,
    ),
    CityLocation(
      id: 'amman',
      nameAr: 'عمّان',
      countryAr: 'الأردن',
      latitude: 31.9454,
      longitude: 35.9284,
      calculationMethod: CalculationMethod.muslim_world_league,
    ),
    CityLocation(
      id: 'damascus',
      nameAr: 'دمشق',
      countryAr: 'سوريا',
      latitude: 33.5138,
      longitude: 36.2765,
      calculationMethod: CalculationMethod.muslim_world_league,
    ),
    CityLocation(
      id: 'beirut',
      nameAr: 'بيروت',
      countryAr: 'لبنان',
      latitude: 33.8938,
      longitude: 35.5018,
      calculationMethod: CalculationMethod.muslim_world_league,
    ),
    CityLocation(
      id: 'baghdad',
      nameAr: 'بغداد',
      countryAr: 'العراق',
      latitude: 33.3152,
      longitude: 44.3661,
      calculationMethod: CalculationMethod.muslim_world_league,
    ),
    CityLocation(
      id: 'tripoli',
      nameAr: 'طرابلس',
      countryAr: 'ليبيا',
      latitude: 32.8872,
      longitude: 13.1913,
      calculationMethod: CalculationMethod.muslim_world_league,
    ),
    CityLocation(
      id: 'tunis',
      nameAr: 'تونس',
      countryAr: 'تونس',
      latitude: 36.8065,
      longitude: 10.1815,
      calculationMethod: CalculationMethod.muslim_world_league,
    ),
    CityLocation(
      id: 'algiers',
      nameAr: 'الجزائر',
      countryAr: 'الجزائر',
      latitude: 36.7538,
      longitude: 3.0588,
      calculationMethod: CalculationMethod.muslim_world_league,
    ),
    CityLocation(
      id: 'rabat',
      nameAr: 'الرباط',
      countryAr: 'المغرب',
      latitude: 34.0209,
      longitude: -6.8416,
      calculationMethod: CalculationMethod.muslim_world_league,
    ),
    CityLocation(
      id: 'khartoum',
      nameAr: 'الخرطوم',
      countryAr: 'السودان',
      latitude: 15.5007,
      longitude: 32.5599,
      calculationMethod: CalculationMethod.egyptian,
    ),
  ];

  CityLocation cityById(String id) {
    for (final c in defaultCities) {
      if (c.id == id) return c;
    }
    return defaultCities.first; // القاهرة
  }

  PrayerTimesDay calculate(CityLocation city, {DateTime? date}) {
    final targetDate = date ?? DateTime.now();
    final coordinates = Coordinates(city.latitude, city.longitude);
    final params = city.calculationMethod.getParameters();
    params.madhab = Madhab.shafi;

    final dateComponents = DateComponents.from(targetDate);
    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

    final fajr = prayerTimes.fajr.toLocal();
    final sunrise = prayerTimes.sunrise.toLocal();
    final dhuhr = prayerTimes.dhuhr.toLocal();
    final asr = prayerTimes.asr.toLocal();
    final maghrib = prayerTimes.maghrib.toLocal();
    final isha = prayerTimes.isha.toLocal();

    final now = DateTime.now();

    // القبلة
    final qiblaAngle = Qibla(coordinates).direction;

    final rawList = [
      PrayerTimeItem(key: 'fajr', name: 'الفجر', time: fajr),
      PrayerTimeItem(key: 'sunrise', name: 'الشروق', time: sunrise),
      PrayerTimeItem(key: 'dhuhr', name: 'الظهر', time: dhuhr),
      PrayerTimeItem(key: 'asr', name: 'العصر', time: asr),
      PrayerTimeItem(key: 'maghrib', name: 'المغرب', time: maghrib),
      PrayerTimeItem(key: 'isha', name: 'العشاء', time: isha),
    ];

    PrayerTimeItem? next;
    Duration? timeRemaining;
    PrayerTimeItem? current;

    for (var i = 0; i < rawList.length; i++) {
      final p = rawList[i];
      if (p.time.isAfter(now)) {
        next = p;
        timeRemaining = p.time.difference(now);
        if (i > 0) current = rawList[i - 1];
        break;
      }
    }

    // إذا انتهت صلوات اليوم، فالصلاة القادمة فجر الغد
    if (next == null) {
      current = rawList.last;
      final tomorrow = targetDate.add(const Duration(days: 1));
      final tomorrowTimes = PrayerTimes(coordinates, DateComponents.from(tomorrow), params);
      final nextFajr = tomorrowTimes.fajr.toLocal();
      next = PrayerTimeItem(key: 'fajr', name: 'الفجر', time: nextFajr);
      timeRemaining = nextFajr.difference(now);
    }

    final finalPrayers = rawList.map((p) {
      final isN = p.key == next?.key;
      final isC = p.key == current?.key;
      return PrayerTimeItem(
        key: p.key,
        name: p.name,
        time: p.time,
        isNext: isN,
        isCurrent: isC,
      );
    }).toList();

    return PrayerTimesDay(
      city: city,
      prayers: finalPrayers,
      nextPrayer: next,
      timeUntilNext: timeRemaining,
      qiblaAngle: qiblaAngle,
      date: targetDate,
    );
  }
}
