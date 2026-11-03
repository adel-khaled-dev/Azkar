import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// عنصر مفضّل: ذكر/دعاء أو آية قرآنية.
class FavoriteEntry {
  final String kind; // 'adhkar' | 'ayah'
  final String id; // معرّف فريد (نصي)
  final String title;
  final String subtitle;
  final String icon;
  final int? surahNumber; // للأية فقط
  final int? ayahNumber; // للأية فقط

  const FavoriteEntry({
    required this.kind,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.surahNumber,
    this.ayahNumber,
  });

  Map<String, dynamic> toJson() => {
        'kind': kind,
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'icon': icon,
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
      };

  factory FavoriteEntry.fromJson(Map<String, dynamic> json) => FavoriteEntry(
        kind: (json['kind'] as String?) ?? 'adhkar',
        id: (json['id'] as String?) ?? '',
        title: (json['title'] as String?) ?? '',
        subtitle: (json['subtitle'] as String?) ?? '',
        icon: (json['icon'] as String?) ?? '',
        surahNumber: (json['surahNumber'] as num?)?.toInt(),
        ayahNumber: (json['ayahNumber'] as num?)?.toInt(),
      );
}

class FavoritesState {
  final List<FavoriteEntry> entries;
  const FavoritesState({this.entries = const []});

  bool contains(String kind, String id) =>
      entries.any((e) => e.kind == kind && e.id == id);

  FavoritesState copyWith({List<FavoriteEntry>? entries}) =>
      FavoritesState(entries: entries ?? this.entries);
}

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesState());

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('favorites');
    if (raw == null || raw.isEmpty) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      emit(FavoritesState(entries: [
        for (final e in list)
          FavoriteEntry.fromJson(e as Map<String, dynamic>),
      ]));
    } catch (_) {
      // بيانات تالفة — نتجاهلها بأمان.
    }
  }

  bool isFavorite(String kind, String id) => state.contains(kind, id);

  Future<void> toggle(FavoriteEntry entry) async {
    final entries = List<FavoriteEntry>.from(state.entries);
    if (state.contains(entry.kind, entry.id)) {
      entries.removeWhere((e) => e.kind == entry.kind && e.id == entry.id);
    } else {
      entries.insert(0, entry);
    }
    emit(FavoritesState(entries: entries));
    await _persist(entries);
  }

  Future<void> remove(String kind, String id) async {
    final entries = state.entries
        .where((e) => !(e.kind == kind && e.id == id))
        .toList();
    emit(FavoritesState(entries: entries));
    await _persist(entries);
  }

  Future<void> _persist(List<FavoriteEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'favorites',
      jsonEncode([for (final e in entries) e.toJson()]),
    );
  }
}
