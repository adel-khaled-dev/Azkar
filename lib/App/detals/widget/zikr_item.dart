class ZikrItem {
  final String category;
  final String arabicText;
  final String translation;
  final int maxCount;

  const ZikrItem({
    required this.category,
    required this.arabicText,
    required this.translation,
    required this.maxCount,
  });
}

const zikrList = [
  ZikrItem(
    category: 'أذكار الصباح',
    arabicText:
        'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ',
    translation: 'أصبحنا وأصبح الملك لله وحده، لا شريك له في ملكه وحمده',
    maxCount: 1,
  ),
  ZikrItem(
    category: 'أذكار الصباح',
    arabicText:
        'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
    translation: 'اللهم بك نبدأ يومنا وبك ننهيه وإليك مصيرنا',
    maxCount: 1,
  ),
  ZikrItem(
    category: 'أذكار الصباح',
    arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    translation: 'تنزيه الله عن كل نقص والثناء عليه بالحمد',
    maxCount: 100,
  ),
];
