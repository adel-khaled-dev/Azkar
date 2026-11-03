import 'package:azkar/core/theme/app_theme.dart';
import 'package:azkar/features/quran/logic/quran_cubit.dart';
import 'package:azkar/features/quran/presentation/mushaf_page_reader.dart';
import 'package:azkar/features/quran/presentation/surah_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة القرآن — خيار فتح المصحف الشريف بتقليب الصفحات + قائمة وفهرس السور.
class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('القرآن الكريم')),
      body: Column(
        children: [
          // بطاقة فتح المصحف المطبوع (604 صفحة)
          BlocBuilder<QuranCubit, QuranState>(
            builder: (context, state) {
              final lastPage = state.lastReadPage;
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: isDark ? AppColors.surfaceDark : AppColors.primarySoft,
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MushafPageReader(initialPage: lastPage),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: isDark
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                width: 1.5,
                              ),
                            )
                          : null,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'قراءة المصحف الشريف',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: isDark ? AppColors.textDark : AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'تقليب صفحات المصحف (604 صفحة) • متابعة صفحة ${toArabicDigits(lastPage)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: theme.colorScheme.primary),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // حقل البحث في السور
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: TextField(
              onChanged: (q) => context.read<QuranCubit>().setQuery(q),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'ابحث عن سورة...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // قائمة السور
          Expanded(
            child: BlocBuilder<QuranCubit, QuranState>(
              builder: (context, state) {
                if (state.status == QuranStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == QuranStatus.error) {
                  return const Center(child: Text('تعذّر تحميل المصحف'));
                }
                final surahs = state.filteredSurahs;
                if (surahs.isEmpty) {
                  return const Center(child: Text('لا توجد نتائج'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  itemCount: surahs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final surah = surahs[i];
                    return _SurahTile(surahNumber: surah.number);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahTile extends StatelessWidget {
  final int surahNumber;
  const _SurahTile({required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        final surah = state.surahByNumber(surahNumber);
        if (surah == null) return const SizedBox.shrink();
        final page = state.pageForSurah(surah.number);

        return Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MushafPageReader(initialPage: page),
              ),
            ),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  _NumberBadge(number: surah.number),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'سورة ${surah.name}',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${surah.type} • ${surah.ayahCount} آية • صفحة ${toArabicDigits(page)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.list_alt_rounded, size: 20),
                    tooltip: 'قراءة قائمة الآيات',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SurahPage(surahNumber: surah.number),
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_left_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NumberBadge extends StatelessWidget {
  final int number;
  const _NumberBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDarkSoft : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$number',
        style: TextStyle(
          color: isDark ? const Color(0xFF26C49B) : theme.colorScheme.primary,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    );
  }
}
