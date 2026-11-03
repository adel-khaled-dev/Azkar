/// نماذج بيانات الأذكار والأدعية.
enum AdhkarKind { azkar, dua }

/// صنف واحد من الأذكار أو الأدعية (نص + ترجمة + مصدر + عدد التكرار).
class AdhkarItem {
  final String id;
  final String categoryId;
  final String text;
  final String translation;
  final String source;
  final int count;

  const AdhkarItem({
    required this.id,
    required this.categoryId,
    required this.text,
    required this.translation,
    required this.source,
    required this.count,
  });

  factory AdhkarItem.fromJson(String categoryId, int index, Map<String, dynamic> json) {
    return AdhkarItem(
      id: '$categoryId:$index',
      categoryId: categoryId,
      text: (json['text'] as String?)?.trim() ?? '',
      translation: (json['translation'] as String?)?.trim() ?? '',
      source: (json['source'] as String?)?.trim() ?? '',
      count: (json['count'] as num?)?.toInt() ?? 1,
    );
  }
}

/// فئة أذكار (مثل: أذكار الصباح، أدعية الأنبياء...).
class AdhkarCategory {
  final String id;
  final String title;
  final AdhkarKind kind;
  final String icon;
  final List<AdhkarItem> items;

  const AdhkarCategory({
    required this.id,
    required this.title,
    required this.kind,
    required this.icon,
    required this.items,
  });

  int get itemCount => items.length;

  factory AdhkarCategory.fromJson(Map<String, dynamic> json) {
    final kindRaw = (json['kind'] as String?)?.toLowerCase();
    final rawItems = (json['items'] as List<dynamic>?) ?? const [];
    final id = (json['id'] as String?)?.trim() ?? '';
    final items = <AdhkarItem>[
      for (var i = 0; i < rawItems.length; i++)
        AdhkarItem.fromJson(id, i, rawItems[i] as Map<String, dynamic>),
    ];
    return AdhkarCategory(
      id: id,
      title: (json['title'] as String?)?.trim() ?? '',
      kind: kindRaw == 'dua' ? AdhkarKind.dua : AdhkarKind.azkar,
      icon: (json['icon'] as String?)?.trim() ?? '',
      items: items,
    );
  }
}
