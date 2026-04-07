class FavoriteItem {
  final String category;
  final String arabicText;
  final String source;
  int count;
  final int maxCount;
  bool isFavorited;

  FavoriteItem({
    required this.category,
    required this.arabicText,
    required this.source,
    required this.count,
    required this.maxCount,
    this.isFavorited = true,
  });
}