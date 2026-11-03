import 'dart:convert';

import 'package:azkar/features/quran/models/surah.dart';
import 'package:flutter/services.dart' show rootBundle;

/// بيانات سورة (الرقم + الاسم + نوعها) — ثابتة لا تتغيّر.
class _SurahMeta {
  final int number;
  final String name;
  final String type;
  const _SurahMeta(this.number, this.name, this.type);
}

/// يقرأ نص المصحف ويبني السور كاملة والصفحات الـ 604 للمصحف الشريف.
class QuranRepository {
  const QuranRepository();

  static const String _bismillah = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ';

  static const List<_SurahMeta> _meta = [
    _SurahMeta(1, 'الفاتحة', 'مكية'),
    _SurahMeta(2, 'البقرة', 'مدنية'),
    _SurahMeta(3, 'آل عمران', 'مدنية'),
    _SurahMeta(4, 'النساء', 'مدنية'),
    _SurahMeta(5, 'المائدة', 'مدنية'),
    _SurahMeta(6, 'الأنعام', 'مكية'),
    _SurahMeta(7, 'الأعراف', 'مكية'),
    _SurahMeta(8, 'الأنفال', 'مدنية'),
    _SurahMeta(9, 'التوبة', 'مدنية'),
    _SurahMeta(10, 'يونس', 'مكية'),
    _SurahMeta(11, 'هود', 'مكية'),
    _SurahMeta(12, 'يوسف', 'مكية'),
    _SurahMeta(13, 'الرعد', 'مدنية'),
    _SurahMeta(14, 'إبراهيم', 'مكية'),
    _SurahMeta(15, 'الحجر', 'مكية'),
    _SurahMeta(16, 'النحل', 'مكية'),
    _SurahMeta(17, 'الإسراء', 'مكية'),
    _SurahMeta(18, 'الكهف', 'مكية'),
    _SurahMeta(19, 'مريم', 'مكية'),
    _SurahMeta(20, 'طه', 'مكية'),
    _SurahMeta(21, 'الأنبياء', 'مكية'),
    _SurahMeta(22, 'الحج', 'مدنية'),
    _SurahMeta(23, 'المؤمنون', 'مكية'),
    _SurahMeta(24, 'النور', 'مدنية'),
    _SurahMeta(25, 'الفرقان', 'مكية'),
    _SurahMeta(26, 'الشعراء', 'مكية'),
    _SurahMeta(27, 'النمل', 'مكية'),
    _SurahMeta(28, 'القصص', 'مكية'),
    _SurahMeta(29, 'العنكبوت', 'مكية'),
    _SurahMeta(30, 'الروم', 'مكية'),
    _SurahMeta(31, 'لقمان', 'مكية'),
    _SurahMeta(32, 'السجدة', 'مكية'),
    _SurahMeta(33, 'الأحزاب', 'مدنية'),
    _SurahMeta(34, 'سبأ', 'مكية'),
    _SurahMeta(35, 'فاطر', 'مكية'),
    _SurahMeta(36, 'يس', 'مكية'),
    _SurahMeta(37, 'الصافات', 'مكية'),
    _SurahMeta(38, 'ص', 'مكية'),
    _SurahMeta(39, 'الزمر', 'مكية'),
    _SurahMeta(40, 'غافر', 'مكية'),
    _SurahMeta(41, 'فصلت', 'مكية'),
    _SurahMeta(42, 'الشورى', 'مكية'),
    _SurahMeta(43, 'الزخرف', 'مكية'),
    _SurahMeta(44, 'الدخان', 'مكية'),
    _SurahMeta(45, 'الجاثية', 'مكية'),
    _SurahMeta(46, 'الأحقاف', 'مكية'),
    _SurahMeta(47, 'محمد', 'مدنية'),
    _SurahMeta(48, 'الفتح', 'مدنية'),
    _SurahMeta(49, 'الحجرات', 'مدنية'),
    _SurahMeta(50, 'ق', 'مكية'),
    _SurahMeta(51, 'الذاريات', 'مكية'),
    _SurahMeta(52, 'الطور', 'مكية'),
    _SurahMeta(53, 'النجم', 'مكية'),
    _SurahMeta(54, 'القمر', 'مكية'),
    _SurahMeta(55, 'الرحمن', 'مدنية'),
    _SurahMeta(56, 'الواقعة', 'مكية'),
    _SurahMeta(57, 'الحديد', 'مدنية'),
    _SurahMeta(58, 'المجادلة', 'مدنية'),
    _SurahMeta(59, 'الحشر', 'مدنية'),
    _SurahMeta(60, 'الممتحنة', 'مدنية'),
    _SurahMeta(61, 'الصف', 'مدنية'),
    _SurahMeta(62, 'الجمعة', 'مدنية'),
    _SurahMeta(63, 'المنافقون', 'مدنية'),
    _SurahMeta(64, 'التغابن', 'مدنية'),
    _SurahMeta(65, 'الطلاق', 'مدنية'),
    _SurahMeta(66, 'التحريم', 'مدنية'),
    _SurahMeta(67, 'الملك', 'مكية'),
    _SurahMeta(68, 'القلم', 'مكية'),
    _SurahMeta(69, 'الحاقة', 'مكية'),
    _SurahMeta(70, 'المعارج', 'مكية'),
    _SurahMeta(71, 'نوح', 'مكية'),
    _SurahMeta(72, 'الجن', 'مكية'),
    _SurahMeta(73, 'المزمل', 'مكية'),
    _SurahMeta(74, 'المدثر', 'مكية'),
    _SurahMeta(75, 'القيامة', 'مكية'),
    _SurahMeta(76, 'الإنسان', 'مدنية'),
    _SurahMeta(77, 'المرسلات', 'مكية'),
    _SurahMeta(78, 'النبأ', 'مكية'),
    _SurahMeta(79, 'النازعات', 'مكية'),
    _SurahMeta(80, 'عبس', 'مكية'),
    _SurahMeta(81, 'التكوير', 'مكية'),
    _SurahMeta(82, 'الانفطار', 'مكية'),
    _SurahMeta(83, 'المطففين', 'مكية'),
    _SurahMeta(84, 'الانشقاق', 'مكية'),
    _SurahMeta(85, 'البروج', 'مكية'),
    _SurahMeta(86, 'الطارق', 'مكية'),
    _SurahMeta(87, 'الأعلى', 'مكية'),
    _SurahMeta(88, 'الغاشية', 'مكية'),
    _SurahMeta(89, 'الفجر', 'مكية'),
    _SurahMeta(90, 'البلد', 'مكية'),
    _SurahMeta(91, 'الشمس', 'مكية'),
    _SurahMeta(92, 'الليل', 'مكية'),
    _SurahMeta(93, 'الضحى', 'مكية'),
    _SurahMeta(94, 'الشرح', 'مكية'),
    _SurahMeta(95, 'التين', 'مكية'),
    _SurahMeta(96, 'العلق', 'مكية'),
    _SurahMeta(97, 'القدر', 'مكية'),
    _SurahMeta(98, 'البينة', 'مدنية'),
    _SurahMeta(99, 'الزلزلة', 'مدنية'),
    _SurahMeta(100, 'العاديات', 'مكية'),
    _SurahMeta(101, 'القارعة', 'مكية'),
    _SurahMeta(102, 'التكاثر', 'مكية'),
    _SurahMeta(103, 'العصر', 'مكية'),
    _SurahMeta(104, 'الهمزة', 'مكية'),
    _SurahMeta(105, 'الفيل', 'مكية'),
    _SurahMeta(106, 'قريش', 'مكية'),
    _SurahMeta(107, 'الماعون', 'مكية'),
    _SurahMeta(108, 'الكوثر', 'مكية'),
    _SurahMeta(109, 'الكافرون', 'مكية'),
    _SurahMeta(110, 'النصر', 'مدنية'),
    _SurahMeta(111, 'المسد', 'مكية'),
    _SurahMeta(112, 'الإخلاص', 'مكية'),
    _SurahMeta(113, 'الفلق', 'مكية'),
    _SurahMeta(114, 'الناس', 'مكية'),
  ];

  static final Map<int, _SurahMeta> _metaByNumber = {
    for (final m in _meta) m.number: m,
  };

  Future<Map<int, List<String>>> _loadRawVerses() async {
    final raw = await rootBundle.loadString('assets/data/quran_uthmani.txt');
    final bySurah = <int, List<String>>{};
    for (final line in raw.split('\n')) {
      final t = line.trim();
      if (t.isEmpty || t.startsWith('#')) continue;
      final first = t.indexOf('|');
      final second = t.indexOf('|', first + 1);
      if (first < 0 || second < 0) continue;
      final surahNum = int.tryParse(t.substring(0, first));
      final ayahNum = int.tryParse(t.substring(first + 1, second));
      if (surahNum == null || ayahNum == null) continue;
      bySurah.putIfAbsent(surahNum, () => []).add(t.substring(second + 1));
    }
    return bySurah;
  }

  Future<List<Surah>> loadSurahs() async {
    final bySurah = await _loadRawVerses();
    final surahs = <Surah>[];
    for (final meta in _meta) {
      final texts = bySurah[meta.number] ?? const <String>[];
      String? bismillah;
      if (meta.number != 1 && meta.number != 9 && texts.isNotEmpty) {
        final first = texts.first;
        if (first.startsWith(_bismillah)) {
          bismillah = _bismillah;
          texts[0] = first.substring(_bismillah.length).trimLeft();
        }
      }
      final ayahs = <Ayah>[
        for (var i = 0; i < texts.length; i++)
          Ayah(number: i + 1, text: texts[i]),
      ];
      surahs.add(Surah(
        number: meta.number,
        name: meta.name,
        type: meta.type,
        bismillah: bismillah,
        ayahs: ayahs,
      ));
    }
    return surahs;
  }

  /// يقرأ ملف تقسيم صفحات المصحف (604 صفحة) ويبني كائنات الصفحات كاملة.
  Future<List<MushafPage>> loadMushafPages() async {
    final rawJson = await rootBundle.loadString('assets/data/mushaf_pages.json');
    final List<dynamic> pageIndexList = jsonDecode(rawJson);
    final bySurah = await _loadRawVerses();

    final pages = <MushafPage>[];

    for (var i = 0; i < pageIndexList.length; i++) {
      final entry = pageIndexList[i] as Map<String, dynamic>;
      final pageNum = (entry['p'] as num).toInt();
      final startSurah = (entry['s'] as num).toInt();
      final startAyah = (entry['a'] as num).toInt();
      final juz = (entry['j'] as num).toInt();
      final hizb = (entry['h'] as num).toInt();

      int endSurah;
      int endAyah;
      if (i + 1 < pageIndexList.length) {
        final nextEntry = pageIndexList[i + 1] as Map<String, dynamic>;
        endSurah = (nextEntry['s'] as num).toInt();
        endAyah = (nextEntry['a'] as num).toInt();
      } else {
        // الصفحة الأخيرة (604)
        endSurah = 114;
        endAyah = 7;
      }

      final pageAyahs = <MushafPageAyah>[];
      final surahNamesInPage = <String>{};

      var curS = startSurah;
      var curA = startAyah;

      while (curS < endSurah || (curS == endSurah && curA < endAyah)) {
        final surahVerses = bySurah[curS];
        if (surahVerses == null || curA > surahVerses.length) {
          curS++;
          curA = 1;
          continue;
        }

        final meta = _metaByNumber[curS];
        final sName = meta?.name ?? '';
        final sType = meta?.type ?? 'مكية';
        surahNamesInPage.add(sName);

        var verseText = surahVerses[curA - 1];
        // إزالة البسملة من أول آية إذا كانت مدمجة في السور عدا الفاتحة
        if (curS != 1 && curS != 9 && curA == 1 && verseText.startsWith(_bismillah)) {
          verseText = verseText.substring(_bismillah.length).trimLeft();
        }

        pageAyahs.add(MushafPageAyah(
          surahNumber: curS,
          surahName: sName,
          surahType: sType,
          ayahNumber: curA,
          text: verseText,
          isFirstAyahInSurah: curA == 1,
        ));

        if (curA == surahVerses.length) {
          curS++;
          curA = 1;
        } else {
          curA++;
        }
      }

      pages.add(MushafPage(
        pageNumber: pageNum,
        juzNumber: juz,
        hizbNumber: hizb,
        surahNames: surahNamesInPage.toList(),
        ayahs: pageAyahs,
      ));
    }

    return pages;
  }
}
