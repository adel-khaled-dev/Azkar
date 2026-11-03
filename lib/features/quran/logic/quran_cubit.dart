import 'package:azkar/features/quran/data/quran_repository.dart';
import 'package:azkar/features/quran/models/surah.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum QuranStatus { loading, loaded, error }

class QuranState {
  final QuranStatus status;
  final List<Surah> surahs;
  final List<MushafPage> mushafPages;
  final Map<int, int> surahStartPages;
  final String query;
  final int? lastReadSurah;
  final int? lastReadAyah;
  final int lastReadPage;

  const QuranState({
    this.status = QuranStatus.loading,
    this.surahs = const [],
    this.mushafPages = const [],
    this.surahStartPages = const {},
    this.query = '',
    this.lastReadSurah,
    this.lastReadAyah,
    this.lastReadPage = 1,
  });

  List<Surah> get filteredSurahs {
    final q = query.trim();
    if (q.isEmpty) return surahs;
    return surahs.where((s) => s.name.contains(q)).toList();
  }

  Surah? surahByNumber(int number) {
    for (final s in surahs) {
      if (s.number == number) return s;
    }
    return null;
  }

  MushafPage? pageByNumber(int pageNumber) {
    final index = pageNumber - 1;
    if (index >= 0 && index < mushafPages.length) {
      return mushafPages[index];
    }
    return null;
  }

  /// إيجاد رقم الصفحة التي تبدأ فيها السورة المحددة بسرعة O(1) فائقة دون أي حلقة تكرار.
  int pageForSurah(int surahNumber) => surahStartPages[surahNumber] ?? 1;

  QuranState copyWith({
    QuranStatus? status,
    List<Surah>? surahs,
    List<MushafPage>? mushafPages,
    Map<int, int>? surahStartPages,
    String? query,
    int? lastReadSurah,
    int? lastReadAyah,
    int? lastReadPage,
  }) {
    return QuranState(
      status: status ?? this.status,
      surahs: surahs ?? this.surahs,
      mushafPages: mushafPages ?? this.mushafPages,
      surahStartPages: surahStartPages ?? this.surahStartPages,
      query: query ?? this.query,
      lastReadSurah: lastReadSurah ?? this.lastReadSurah,
      lastReadAyah: lastReadAyah ?? this.lastReadAyah,
      lastReadPage: lastReadPage ?? this.lastReadPage,
    );
  }
}

class QuranCubit extends Cubit<QuranState> {
  final QuranRepository _repository;

  QuranCubit({QuranRepository repository = const QuranRepository()})
      : _repository = repository,
        super(const QuranState());

  Future<void> load() async {
    if (state.status == QuranStatus.loaded) return;
    try {
      final surahs = await _repository.loadSurahs();
      final mushafPages = await _repository.loadMushafPages();

      // بناء خريطة أرقام الصفحات لكل سورة مسبقاً لمنع أي بطء
      final surahPagesMap = <int, int>{};
      for (final p in mushafPages) {
        for (final a in p.ayahs) {
          if (a.isFirstAyahInSurah) {
            surahPagesMap.putIfAbsent(a.surahNumber, () => p.pageNumber);
          }
        }
      }

      final prefs = await SharedPreferences.getInstance();
      final lastPage = prefs.getInt('lastReadPage') ?? 1;
      final lastSurah = prefs.getInt('lastReadSurah');
      final lastAyah = prefs.getInt('lastReadAyah');

      emit(state.copyWith(
        status: QuranStatus.loaded,
        surahs: surahs,
        mushafPages: mushafPages,
        surahStartPages: surahPagesMap,
        lastReadPage: lastPage,
        lastReadSurah: lastSurah,
        lastReadAyah: lastAyah,
      ));
    } catch (_) {
      emit(state.copyWith(status: QuranStatus.error));
    }
  }

  void setQuery(String query) => emit(state.copyWith(query: query));

  Future<void> saveLastReadPage(int page) async {
    emit(state.copyWith(lastReadPage: page));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastReadPage', page);
  }

  Future<void> saveLastRead(int surah, int ayah) async {
    emit(state.copyWith(lastReadSurah: surah, lastReadAyah: ayah));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastReadSurah', surah);
    await prefs.setInt('lastReadAyah', ayah);
  }
}
