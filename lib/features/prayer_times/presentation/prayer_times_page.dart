import 'package:azkar/core/theme/app_theme.dart';
import 'package:azkar/core/utils/date_formats.dart';
import 'package:azkar/features/prayer_times/data/prayer_repository.dart';
import 'package:azkar/features/prayer_times/logic/prayer_cubit.dart';
import 'package:azkar/features/prayer_times/models/prayer_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة مواقيت الصلاة والقبلة.
class PrayerTimesPage extends StatelessWidget {
  const PrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مواقيت الصلاة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_rounded),
            tooltip: 'تغيير المدينة',
            onPressed: () => _showCityPicker(context),
          ),
        ],
      ),
      body: BlocBuilder<PrayerCubit, PrayerState>(
        builder: (context, state) {
          if (state.isLoading || state.times == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final day = state.times!;
          return RefreshIndicator(
            onRefresh: () => context.read<PrayerCubit>().load(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                _HeroPrayerCard(day: day, onCityTap: () => _showCityPicker(context)),
                const SizedBox(height: 20),
                _NotificationToggle(state: state),
                const SizedBox(height: 20),
                Text(
                  'جدول الصلوات اليوم',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                ...day.prayers.map((prayer) => _PrayerCard(prayer: prayer)),
                const SizedBox(height: 20),
                _QiblaCard(qiblaAngle: day.qiblaAngle, cityName: day.city.nameAr),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCityPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => const _CityPickerSheet(),
    );
  }
}

class _HeroPrayerCard extends StatelessWidget {
  final PrayerTimesDay day;
  final VoidCallback onCityTap;

  const _HeroPrayerCard({required this.day, required this.onCityTap});

  @override
  Widget build(BuildContext context) {
    final next = day.nextPrayer;
    final remaining = day.timeUntilNext;

    String countdownText = '';
    if (remaining != null) {
      final hours = remaining.inHours.toString().padLeft(2, '0');
      final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
      countdownText = '$hours ساعة و $minutes دقيقة';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.primaryDeep, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: onCityTap,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_rounded, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        day.city.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Text(
                AppDates.hijriFull,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'الصلاة القادمة',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                next?.name ?? 'الفجر',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                next?.formattedTime ?? '',
                style: TextStyle(
                  color: AppColors.goldSoft,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (countdownText.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, color: Colors.white70, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'متبقي: $countdownText',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  final PrayerState state;
  const _NotificationToggle({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: state.notificationsEnabled
                    ? AppColors.primarySoft
                    : theme.colorScheme.onSurface.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                state.notificationsEnabled
                    ? Icons.notifications_active_rounded
                    : Icons.notifications_off_rounded,
                color: state.notificationsEnabled
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('إشعارات الأذان', style: TextStyle(fontWeight: FontWeight.w700)),
                  Text(
                    state.notificationsEnabled
                        ? 'تنبيه بحلول كل صلاة مفعّل'
                        : 'تم كتم إشعارات الأذان',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: state.notificationsEnabled,
              onChanged: (val) => context.read<PrayerCubit>().setNotificationsEnabled(val),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerCard extends StatelessWidget {
  final PrayerTimeItem prayer;
  const _PrayerCard({required this.prayer});

  IconData _iconFor(String key) {
    switch (key) {
      case 'fajr':
        return Icons.wb_twilight_rounded;
      case 'sunrise':
        return Icons.wb_sunny_outlined;
      case 'dhuhr':
        return Icons.wb_sunny_rounded;
      case 'asr':
        return Icons.brightness_medium_rounded;
      case 'maghrib':
        return Icons.nights_stay_rounded;
      case 'isha':
        return Icons.bedtime_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNext = prayer.isNext;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: isNext
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isNext
                      ? theme.colorScheme.primary.withValues(alpha: 0.2)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _iconFor(prayer.key),
                  color: isNext ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      prayer.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isNext ? FontWeight.w800 : FontWeight.w600,
                        color: isNext ? theme.colorScheme.primary : null,
                      ),
                    ),
                    if (isNext) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'القادمة',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                prayer.formattedTime,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isNext ? theme.colorScheme.primary : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QiblaCard extends StatelessWidget {
  final double qiblaAngle;
  final String cityName;

  const _QiblaCard({required this.qiblaAngle, required this.cityName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rounded = qiblaAngle.round();
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.goldSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Transform.rotate(
                angle: (qiblaAngle * 3.14159 / 180),
                child: const Icon(Icons.explore_rounded, color: AppColors.gold, size: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('اتجاه القبلة الشريفة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 3),
                  Text(
                    'زاوية $rounded° من الشمال نحو الكعبة المشرفة ($cityName)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
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

class _CityPickerSheet extends StatefulWidget {
  const _CityPickerSheet();

  @override
  State<_CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<_CityPickerSheet> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allCities = PrayerRepository.defaultCities;
    final filtered = _filter.isEmpty
        ? allCities
        : allCities
            .where((c) =>
                c.nameAr.contains(_filter.trim()) ||
                c.countryAr.contains(_filter.trim()))
            .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollController) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'اختر مدينتك لمواقيت الصلاة',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            TextField(
              onChanged: (v) => setState(() => _filter = v),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث عن محافظة أو دولة...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final city = filtered[i];
                  final isSelected = ctx.watch<PrayerCubit>().state.city.id == city.id;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    leading: Icon(
                      Icons.location_city_rounded,
                      color: isSelected ? theme.colorScheme.primary : null,
                    ),
                    title: Text(
                      city.nameAr,
                      style: TextStyle(fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500),
                    ),
                    subtitle: Text(city.countryAr),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary)
                        : null,
                    onTap: () {
                      ctx.read<PrayerCubit>().selectCity(city);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
