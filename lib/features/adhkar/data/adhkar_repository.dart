import 'dart:convert';

import 'package:azkar/features/adhkar/models/adhkar_models.dart';
import 'package:flutter/services.dart' show rootBundle;

/// يقرأ ملفات بيانات الأذكار/الأدعية من الأصول ويحوّلها لنماذج.
class AdhkarRepository {
  const AdhkarRepository();

  static const List<String> _files = [
    'assets/data/azkar.json',
    'assets/data/duas.json',
    'assets/data/names.json',
  ];

  Future<List<AdhkarCategory>> loadCategories() async {
    final result = <AdhkarCategory>[];
    for (final file in _files) {
      final raw = await rootBundle.loadString(file);
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) continue;
      final list = decoded['categories'] as List<dynamic>? ?? const [];
      for (final entry in list) {
        if (entry is Map<String, dynamic>) {
          result.add(AdhkarCategory.fromJson(entry));
        }
      }
    }
    return result;
  }
}
