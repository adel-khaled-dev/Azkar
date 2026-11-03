import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// خدمة الإشعارات المحلية — أذان الصلوات الخمس والتذكير بالصلاة على النبي ﷺ.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  Timer? _salawatTimer;

  static const String adhanChannelId = 'adhan_channel';
  static const String adhanChannelName = 'تنبيهات مواعيد الأذان';

  static const String salawatChannelId = 'salawat_channel';
  static const String salawatChannelName = 'التذكير بالصلاة على النبي';

  static const int instantSalawatNotificationId = 998;
  static const int salawatNotificationId = 999;
  static const int batchSalawatStartId = 2000;
  static const int batchSalawatCount = 15;

  static const Map<String, int> _prayerIds = {
    'fajr': 101,
    'dhuhr': 102,
    'asr': 103,
    'maghrib': 104,
    'isha': 105,
  };

  Future<void> init() async {
    if (_initialized) return;

    try {
      tz.initializeTimeZones();
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      try {
        final locations = tz.timeZoneDatabase.locations;
        tz.Location? matched;
        for (final loc in locations.values) {
          if (loc.currentTimeZone.offset == offset.inMilliseconds) {
            matched = loc;
            break;
          }
        }
        if (matched != null) {
          tz.setLocalLocation(matched);
        }
      } catch (_) {
        // الاستمرار بالمنطقة الافتراضية
      }

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidInit,
        iOS: darwinInit,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          debugPrint('Notification clicked: ${response.payload}');
        },
      );

      if (Platform.isAndroid) {
        final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        if (androidPlugin != null) {
          await androidPlugin.createNotificationChannel(
            const AndroidNotificationChannel(
              adhanChannelId,
              adhanChannelName,
              description: 'إشعارات حلول مواقيت الصلاة الخمس',
              importance: Importance.max,
              playSound: true,
              enableVibration: true,
            ),
          );

          await androidPlugin.createNotificationChannel(
            const AndroidNotificationChannel(
              salawatChannelId,
              salawatChannelName,
              description: 'تذكير دوري بالصلاة على النبي ﷺ',
              importance: Importance.high,
              playSound: true,
              enableVibration: true,
            ),
          );

          await androidPlugin.requestNotificationsPermission();

          try {
            await androidPlugin.requestExactAlarmsPermission();
          } catch (_) {}
        }
      }

      _initialized = true;
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
    }
  }

  /// إرسال إشعار فوري بالصلاة على النبي ﷺ فور تفعيل الميزة أو تعديل وقتها.
  Future<void> showInstantSalawat() async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      salawatChannelId,
      salawatChannelName,
      channelDescription: 'تذكير فوري بالصلاة على النبي',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    try {
      await _notifications.show(
        instantSalawatNotificationId,
        'صلِّ على الحبيب ﷺ ✨',
        'اللهم صلِّ وسلِّم وبارك على نبينا وحبيبنا محمد ﷺ',
        const NotificationDetails(android: androidDetails, iOS: iosDetails),
      );
    } catch (e) {
      debugPrint('Error showing instant salawat notification: $e');
    }
  }

  /// جدولة إشعار الأذان لوقت صلاة معين.
  Future<void> schedulePrayer({
    required String prayerKey,
    required String prayerName,
    required DateTime time,
    required String cityName,
  }) async {
    if (!_initialized) await init();
    final id = _prayerIds[prayerKey] ?? 100;

    final scheduledDate = tz.TZDateTime.from(time, tz.local);
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    const androidDetails = AndroidNotificationDetails(
      adhanChannelId,
      adhanChannelName,
      channelDescription: 'تنبيه بحلول موعد الأذان',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    try {
      await _notifications.zonedSchedule(
        id,
        'حان الآن موعد أذان $prayerName 🕌',
        'حيّ على الصلاة.. حيّ على الفلاح (بتوقيت $cityName)',
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (_) {
      try {
        await _notifications.zonedSchedule(
          id,
          'حان الآن موعد أذان $prayerName 🕌',
          'حيّ على الصلاة.. حيّ على الفلاح (بتوقيت $cityName)',
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (e) {
        debugPrint('Error scheduling prayer notification for $prayerName: $e');
      }
    }
  }

  /// إلغاء إشعارات الأذان المجدولة.
  Future<void> cancelPrayerNotifications() async {
    for (final id in _prayerIds.values) {
      await _notifications.cancel(id);
    }
  }

  /// تفعيل إشعارات الصلاة على النبي بالفاصل الزمني المختار (بالدقائق: 10, 20, 30, 45, 60).
  Future<void> scheduleSalawat({required int intervalMinutes}) async {
    if (!_initialized) await init();

    await cancelSalawat();

    const androidDetails = AndroidNotificationDetails(
      salawatChannelId,
      salawatChannelName,
      channelDescription: 'تذكير دوري بالصلاة على النبي',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    try {
      if (intervalMinutes == 60) {
        await _notifications.periodicallyShow(
          salawatNotificationId,
          'صلِّ على الحبيب ﷺ ✨',
          'اللهم صلِّ وسلِّم وبارك على نبينا وحبيبنا محمد ﷺ',
          RepeatInterval.hourly,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } else {
        final now = tz.TZDateTime.now(tz.local);
        for (var i = 0; i < batchSalawatCount; i++) {
          final target = now.add(Duration(minutes: (i + 1) * intervalMinutes));
          try {
            await _notifications.zonedSchedule(
              batchSalawatStartId + i,
              'صلِّ على الحبيب ﷺ ✨',
              'اللهم صلِّ وسلِّم وبارك على نبينا وحبيبنا محمد ﷺ',
              target,
              details,
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
            );
          } catch (_) {
            try {
              await _notifications.zonedSchedule(
                batchSalawatStartId + i,
                'صلِّ على الحبيب ﷺ ✨',
                'اللهم صلِّ وسلِّم وبارك على نبينا وحبيبنا محمد ﷺ',
                target,
                details,
                androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime,
              );
            } catch (e2) {
              debugPrint('Error scheduling salawat #$i: $e2');
            }
          }
        }
      }

      // مؤقت دوري أثناء فتح التطبيق
      _salawatTimer = Timer.periodic(Duration(minutes: intervalMinutes), (_) {
        showInstantSalawat();
      });
    } catch (e) {
      debugPrint('Error scheduling salawat notifications: $e');
    }
  }

  /// إلغاء كافة إشعارات الصلاة على النبي المجدولة والمؤقتات.
  Future<void> cancelSalawat() async {
    _salawatTimer?.cancel();
    _salawatTimer = null;
    try {
      await _notifications.cancel(salawatNotificationId);
    } catch (_) {}
    for (var i = 0; i < batchSalawatCount; i++) {
      try {
        await _notifications.cancel(batchSalawatStartId + i);
      } catch (_) {}
    }
  }
}
