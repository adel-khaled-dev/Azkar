import 'package:azkar/core/services/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool isDark;
  final bool salawatEnabled;
  final int salawatIntervalMinutes; // 10, 20, 30, 45, 60

  const SettingsState({
    this.isDark = false,
    this.salawatEnabled = true,
    this.salawatIntervalMinutes = 60,
  });

  SettingsState copyWith({
    bool? isDark,
    bool? salawatEnabled,
    int? salawatIntervalMinutes,
  }) =>
      SettingsState(
        isDark: isDark ?? this.isDark,
        salawatEnabled: salawatEnabled ?? this.salawatEnabled,
        salawatIntervalMinutes: salawatIntervalMinutes ?? this.salawatIntervalMinutes,
      );
}

class SettingsCubit extends Cubit<SettingsState> {
  final NotificationService _notificationService;

  SettingsCubit({NotificationService? notificationService})
      : _notificationService = notificationService ?? NotificationService(),
        super(const SettingsState());

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    final salawatEnabled = prefs.getBool('salawat_enabled') ?? true;
    final salawatInterval = prefs.getInt('salawat_interval') ?? 60;

    emit(SettingsState(
      isDark: isDark,
      salawatEnabled: salawatEnabled,
      salawatIntervalMinutes: salawatInterval,
    ));

    if (salawatEnabled) {
      await _notificationService.scheduleSalawat(intervalMinutes: salawatInterval);
    }
  }

  void toggleDark() {
    final next = !state.isDark;
    emit(state.copyWith(isDark: next));
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isDark', next);
    });
  }

  Future<void> toggleSalawat() async {
    final next = !state.salawatEnabled;
    emit(state.copyWith(salawatEnabled: next));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('salawat_enabled', next);

    if (next) {
      // إرسال إشعار فوري للتأكيد ثم بدء الجدولة
      await _notificationService.showInstantSalawat();
      await _notificationService.scheduleSalawat(
        intervalMinutes: state.salawatIntervalMinutes,
      );
    } else {
      await _notificationService.cancelSalawat();
    }
  }

  Future<void> setSalawatInterval(int minutes) async {
    emit(state.copyWith(salawatIntervalMinutes: minutes));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('salawat_interval', minutes);

    if (state.salawatEnabled) {
      // إرسال إشعار فوري فور تغيير المدة وإعادة الجدولة
      await _notificationService.showInstantSalawat();
      await _notificationService.scheduleSalawat(intervalMinutes: minutes);
    }
  }
}
