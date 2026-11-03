import 'package:azkar/features/favorites/logic/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// زر مفضّلة موحّد (يُستخدم مع الأذكار والأدعية والآيات).
class FavoriteButton extends StatelessWidget {
  final String kind;
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final bool compact;
  final int? surahNumber;
  final int? ayahNumber;

  const FavoriteButton({
    super.key,
    required this.kind,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.compact = false,
    this.surahNumber,
    this.ayahNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favState) {
        final isFav = favState.contains(kind, id);
        return IconButton(
          onPressed: () => context.read<FavoritesCubit>().toggle(
                FavoriteEntry(
                  kind: kind,
                  id: id,
                  title: title,
                  subtitle: subtitle,
                  icon: icon,
                  surahNumber: surahNumber,
                  ayahNumber: ayahNumber,
                ),
              ),
          visualDensity: compact ? VisualDensity.compact : null,
          padding: compact ? EdgeInsets.zero : null,
          constraints: compact
              ? const BoxConstraints(minWidth: 34, minHeight: 34)
              : null,
          iconSize: compact ? 18 : 24,
          icon: Icon(
            isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            color: isFav ? Theme.of(context).colorScheme.primary : null,
          ),
          tooltip: isFav ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
        );
      },
    );
  }
}
