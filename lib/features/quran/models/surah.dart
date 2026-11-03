/// نموذج سورة وآية وصفحة مصحف من القرآن الكريم.
class Ayah {
  final int number; // رقم الآية داخل السورة (يبدأ من 1)
  final String text;

  const Ayah({required this.number, required this.text});
}

class Surah {
  final int number; // رقم السورة (1..114)
  final String name; // اسم السورة
  final String type; // مكية / مدنية
  final String? bismillah; // البسملة كترويسة (فارغ للفاتحة والتوبة)
  final List<Ayah> ayahs;

  const Surah({
    required this.number,
    required this.name,
    required this.type,
    required this.ayahs,
    this.bismillah,
  });

  int get ayahCount => ayahs.length;
}

/// آية تقع ضمن صفحة مصحف مع معلومات السورة الخاصة بها.
class MushafPageAyah {
  final int surahNumber;
  final String surahName;
  final String surahType;
  final int ayahNumber;
  final String text;
  final bool isFirstAyahInSurah;

  const MushafPageAyah({
    required this.surahNumber,
    required this.surahName,
    required this.surahType,
    required this.ayahNumber,
    required this.text,
    this.isFirstAyahInSurah = false,
  });
}

/// صفحة واحدة من صفحات المصحف الشريف الـ 604 (مصحف المدينة).
class MushafPage {
  final int pageNumber; // 1..604
  final int juzNumber; // 1..30
  final int hizbNumber; // 1..60
  final List<String> surahNames;
  final List<MushafPageAyah> ayahs;

  const MushafPage({
    required this.pageNumber,
    required this.juzNumber,
    required this.hizbNumber,
    required this.surahNames,
    required this.ayahs,
  });

  String get headerSurahName => surahNames.isNotEmpty ? 'سورة ${surahNames.first}' : '';
  String get headerJuzHizb => 'الجزء $juzNumber • الحزب $hizbNumber';
}
