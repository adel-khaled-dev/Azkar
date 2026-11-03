import 'package:azkar/app.dart';
import 'package:azkar/core/services/notification_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const AzkarApp());
}
