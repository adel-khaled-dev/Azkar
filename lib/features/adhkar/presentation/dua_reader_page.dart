import 'package:azkar/core/widgets/favorite_button.dart';
import 'package:azkar/features/adhkar/models/adhkar_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// قارئ الأدعية — قائمة تمرير لكل أدعية الفئة.
class DuaReaderPage extends StatelessWidget {
  final AdhkarCategory category;

  const DuaReaderPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        itemCount: category.items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 14),
        itemBuilder: (context, i) =>
            _DuaCard(item: category.items[i], category: category),
      ),
    );
  }
}

class _DuaCard extends StatelessWidget {
  final AdhkarItem item;
  final AdhkarCategory category;

  const _DuaCard({required this.item, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.text,
              textAlign: TextAlign.right,
              style: theme.textTheme.titleMedium?.copyWith(
                height: 1.9,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (item.translation.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                item.translation,
                textAlign: TextAlign.right,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.7,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                if (item.source.isNotEmpty)
                  Expanded(
                    child: Text(
                      item.source,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: item.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ الدعاء')),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 19),
                  tooltip: 'نسخ',
                ),
                FavoriteButton(
                  kind: 'adhkar',
                  id: item.id,
                  title: item.text,
                  subtitle: '${category.title} • ${item.source}',
                  icon: category.icon,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
