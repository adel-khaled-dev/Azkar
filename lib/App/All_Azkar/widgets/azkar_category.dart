// ─── Data ─────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class AzkarCategory {
  final String title;
  final String count;
  final IconData icon;

  const AzkarCategory({
    required this.title,
    required this.count,
    required this.icon,
  });
}

const categories = [
  AzkarCategory(title: 'أذكار الصباح',   count: '٣٣ ذكراً', icon: Icons.wb_sunny_rounded),
  AzkarCategory(title: 'أذكار المساء',   count: '٣٣ ذكراً', icon: Icons.nights_stay_rounded),
  AzkarCategory(title: 'أذكار النوم',    count: '١٧ ذكراً', icon: Icons.bedtime_rounded),
  AzkarCategory(title: 'أذكار الصلاة',  count: '٢٠ ذكراً', icon: Icons.mosque_rounded),
  AzkarCategory(title: 'أذكار السفر',   count: '١٢ ذكراً', icon: Icons.flight_rounded),
  AzkarCategory(title: 'أذكار الطعام',  count: '١٠ أذكار', icon: Icons.restaurant_rounded),
];
