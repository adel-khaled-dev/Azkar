import 'package:azkar/core/theme/app_theme.dart';
import 'package:azkar/core/utils/icon_resolver.dart';
import 'package:azkar/features/adhkar/logic/adhkar_cubit.dart';
import 'package:azkar/features/adhkar/models/adhkar_models.dart';
import 'package:azkar/features/adhkar/presentation/dhikr_detail_page.dart';
import 'package:azkar/features/adhkar/presentation/dua_reader_page.dart';
import 'package:azkar/features/favorites/logic/favorites_cubit.dart';
import 'package:azkar/features/quran/presentation/surah_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة المفضلة.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة')),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.entries.isEmpty) {
            return const _EmptyState();
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            itemCount: state.entries.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _FavoriteCard(entry: state.entries[i]),
          );
        },
      ),
    );
  }
}

void _openEntry(BuildContext context, FavoriteEntry entry) {
  if (entry.kind == 'ayah') {
    if (entry.surahNumber != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SurahPage(surahNumber: entry.surahNumber!),
        ),
      );
    }
    return;
  }

  // ذكر أو دعاء: المعرّف بصيغة "categoryId:index".
  final idx = entry.id.lastIndexOf(':');
  final categoryId = idx >= 0 ? entry.id.substring(0, idx) : entry.id;
  final itemIndex =
      idx >= 0 ? int.tryParse(entry.id.substring(idx + 1)) ?? 0 : 0;

  final adhkarState = context.read<AdhkarCubit>().state;
  final category = adhkarState.categoryById(categoryId);
  if (category == null) return;

  final Widget page = category.kind == AdhkarKind.azkar
      ? DhikrDetailPage(category: category, initialIndex: itemIndex)
      : DuaReaderPage(category: category);
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

class _FavoriteCard extends StatelessWidget {
  final FavoriteEntry entry;
  const _FavoriteCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => _openEntry(context, entry),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  entry.kind == 'ayah'
                      ? Icons.menu_book_rounded
                      : resolveIcon(entry.icon),
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context
                    .read<FavoritesCubit>()
                    .remove(entry.kind, entry.id),
                icon: Icon(
                  Icons.bookmark_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                tooltip: 'إزالة',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد مفضلة بعد',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'أضف الأذكار والآيات المفضلة لديك لتظهر هنا',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
