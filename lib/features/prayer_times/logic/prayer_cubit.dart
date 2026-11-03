import 'dart:async';

import 'package:azkar/core/services/notification_service.dart';
import 'package:azkar/features/prayer_times/data/prayer_repository.dart';
import 'package:azkar/features/prayer_times/models/prayer_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerState {
  final PrayerTimesDay? times;
  final CityLocation city;
  final bool isLoading;
  final bool notificationsEnabled;

  const PrayerState({
    this.times,
    required this.city,
    this.isLoading = true,
    this.notificationsEnabled = true,
  });

  PrayerState copyWith({
    PrayerTimesDay? times,
    CityLocation? city,
    bool? isLoading,
    bool? notificationsEnabled,
  }) {
    return PrayerState(
      times: times ?? this.times,
      city: city ?? this.city,
      isLoading: isLoading ?? this.isLoading,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class PrayerCubit extends Cubit<PrayerState> {
  final PrayerRepository _repository;
  final NotificationService _notificationService;
  Timer? _ticker;

  PrayerCubit({
    PrayerRepository repository = const PrayerRepository(),
    NotificationService? notificationService,
  })  : _repository = repository,
        _notificationService = notificationService ?? NotificationService(),
        super(PrayerState(
          city: PrayerRepository.defaultCities.first,
        )) {
    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (state.times != null) {
        _recalculateTimes(state.city);
      }
    });
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCityId = prefs.getString('prayer_city_id') ?? 'cairo';
      final notificationsEnabled = prefs.getBool('prayer_notifications') ?? true;

      final city = _repository.cityById(savedCityId);
      final day = _repository.calculate(city);

      emit(state.copyWith(
        city: city,
        times: day,
        isLoading: false,
        notificationsEnabled: notificationsEnabled,
      ));

      if (notificationsEnabled) {
        await _schedulePrayers(day);
      }
    } catch (_) {
      final day = _repository.calculate(state.city);
      emit(state.copyWith(times: day, isLoading: false));
    }
  }

  Future<void> selectCity(CityLocation city) async {
    emit(state.copyWith(isLoading: true, city: city));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('prayer_city_id', city.id);

    final day = _repository.calculate(city);
    emit(state.copyWith(times: day, isLoading: false));

    if (state.notificationsEnabled) {
      await _schedulePrayers(day);
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    emit(state.copyWith(notificationsEnabled: enabled));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('prayer_notifications', enabled);

    if (enabled && state.times != null) {
      await _schedulePrayers(state.times!);
    } else {
      await _notificationService.cancelPrayerNotifications();
    }
  }

  void _recalculateTimes(CityLocation city) {
    final day = _repository.calculate(city);
    emit(state.copyWith(times: day));
  }

  Future<void> _schedulePrayers(PrayerTimesDay day) async {
    await _notificationService.cancelPrayerNotifications();
    for (final p in day.prayers) {
      if (p.key == 'sunrise') continue; // لا أذان للشروق
      if (p.time.isAfter(DateTime.now())) {
        await _notificationService.schedulePrayer(
          prayerKey: p.key,
          prayerName: p.name,
          time: p.time,
          cityName: day.city.nameAr,
        );
      }
    }
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
