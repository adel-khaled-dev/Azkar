import 'package:azkar/core/theme/app_theme.dart';
import 'package:azkar/features/adhkar/logic/adhkar_cubit.dart';
import 'package:azkar/features/adhkar/models/adhkar_models.dart';
import 'package:azkar/features/adhkar/presentation/dhikr_detail_page.dart';
import 'package:azkar/features/adhkar/presentation/dua_reader_page.dart';
import 'package:azkar/features/quran/logic/quran_cubit.dart';
import 'package:azkar/features/quran/models/surah.dart';
import 'package:azkar/features/quran/presentation/surah_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة البحث الشامل (أذكار + أدعية + سور).
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adhkarState = context.watch<AdhkarCubit>().state;
    final quranState = context.watch<QuranCubit>().state;

    final q = _query.trim();
    final items = q.isEmpty ? const <AdhkarItem>[] : adhkarState.searchItems(q);
    final surahs = q.isEmpty
        ? const <Surah>[]
        : quranState.surahs.where((s) => s.name.contains(q)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('بحث')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: TextField(
              autofocus: true,
              onChanged: (value) => setState(() => _query = value),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث في الأذكار والأدعية والسور...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(() => _query = ''),
                      ),
                filled: true,
                fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: q.isEmpty
                ? const _Hint()
                : (items.isEmpty && surahs.isEmpty)
                    ? const _NoResults()
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                        children: [
                          if (surahs.isNotEmpty) ...[
                            const _ResultHeader(title: 'السور'),
                            for (final s in surahs.take(8))
                              _SurahResult(surah: s),
                            const SizedBox(height: 16),
                          ],
                          if (items.isNotEmpty) ...[
                            const _ResultHeader(title: 'الأذكار والأدعية'),
                            for (final i in items.take(20))
                              _ItemResult(item: i),
                          ],
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

class _SurahResult extends StatelessWidget {
  final Surah surah;
  const _SurahResult({required this.surah});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${surah.number}',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      title: Text('سورة ${surah.name}'),
      subtitle: Text('${surah.type} • ${surah.ayahCount} آية'),
      trailing: const Icon(Icons.chevron_left_rounded),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SurahPage(surahNumber: surah.number)),
      ),
    );
  }
}

class _ItemResult extends StatelessWidget {
  final AdhkarItem item;
  const _ItemResult({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.read<AdhkarCubit>().state;
    final category = state.categoryById(item.categoryId);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.format_quote_rounded,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        item.text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(category?.title ?? ''),
      onTap: () {
        if (category == null) return;
        final idx = item.id.lastIndexOf(':');
        final index =
            idx >= 0 ? int.tryParse(item.id.substring(idx + 1)) ?? 0 : 0;
        final page = category.kind == AdhkarKind.azkar
            ? DhikrDetailPage(category: category, initialIndex: index)
            : DuaReaderPage(category: category);
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}

class _ResultHeader extends StatelessWidget {
  final String title;
  const _ResultHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 6),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'ابحث عن أي ذكر أو دعاء أو سورة',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('لا توجد نتائج مطابقة'));
  }
}
