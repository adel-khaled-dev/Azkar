import 'package:azkar/core/constants/app_constants.dart';
import 'package:azkar/core/theme/app_theme.dart';
import 'package:azkar/core/utils/date_formats.dart';
import 'package:azkar/core/utils/icon_resolver.dart';
import 'package:azkar/features/adhkar/logic/adhkar_cubit.dart';
import 'package:azkar/features/adhkar/models/adhkar_models.dart';
import 'package:azkar/features/adhkar/presentation/categories_page.dart';
import 'package:azkar/features/adhkar/presentation/dhikr_detail_page.dart';
import 'package:azkar/features/favorites/presentation/favorites_page.dart';
import 'package:azkar/features/prayer_times/logic/prayer_cubit.dart';
import 'package:azkar/features/quran/logic/quran_cubit.dart';
import 'package:azkar/features/quran/presentation/mushaf_page_reader.dart';
import 'package:azkar/features/quran/presentation/quran_page.dart';
import 'package:azkar/features/search/presentation/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// الصفحة الرئيسية — لوحة تحكم شاملة مع وصول سريع للمفضلة والقرآن والأذكار.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<AdhkarCubit>().load();
            context.read<QuranCubit>().load();
            context.read<PrayerCubit>().load();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: const [
              _Header(),
              SizedBox(height: 20),
              _HeroCard(),
              SizedBox(height: 24),
              _QuickAccess(),
              SizedBox(height: 24),
              _ContinueReading(),
              SizedBox(height: 24),
              _FeaturedCategories(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── الترويسة ───────────────────────────
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppDates.greeting,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppConstants.appName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const FavoritesPage()),
          ),
          icon: const Icon(Icons.bookmark_rounded),
          tooltip: 'المفضلة',
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SearchPage()),
          ),
          icon: const Icon(Icons.search_rounded),
          tooltip: 'بحث',
        ),
      ],
    );
  }
}

// ─────────────────────────── بطاقة الترحيب ───────────────────────────
class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.primaryDeep, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      AppDates.hijriFull,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'ابدأ يومك بذكر الله',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'أذكار الصباح والمساء، أدعية مأثورة، ومصحف شريف',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryDeep,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CategoriesPage(kind: AdhkarKind.azkar),
              ),
            ),
            icon: const Icon(Icons.auto_stories_rounded, size: 18),
            label: const Text(
              'ابدأ الأذكار',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── الوصول السريع ───────────────────────────
class _QuickAccess extends StatelessWidget {
  const _QuickAccess();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'وصول سريع',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _QuickCard(
                title: 'الأذكار',
                subtitle: 'صباح ومساء',
                icon: Icons.wb_sunny_rounded,
                color: AppColors.amber,
                soft: AppColors.amberSoft,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CategoriesPage(kind: AdhkarKind.azkar),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickCard(
                title: 'الأدعية',
                subtitle: 'مأثورة وقرآنية',
                icon: Icons.volunteer_activism_rounded,
                color: AppColors.primary,
                soft: AppColors.primarySoft,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CategoriesPage(kind: AdhkarKind.dua),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickCard(
                title: 'المصحف',
                subtitle: '604 صفحة',
                icon: Icons.auto_stories_rounded,
                color: AppColors.blue,
                soft: AppColors.blueSoft,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const QuranPage()),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickCard(
                title: 'المفضلة',
                subtitle: 'المحفوظات',
                icon: Icons.bookmark_rounded,
                color: AppColors.rose,
                soft: AppColors.roseSoft,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FavoritesPage()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color soft;
  final VoidCallback onTap;

  const _QuickCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.soft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.surfaceDark : soft,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark ? color.withValues(alpha: 0.35) : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? color.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── متابعة القراءة ───────────────────────────
class _ContinueReading extends StatelessWidget {
  const _ContinueReading();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<QuranCubit, QuranState>(
      builder: (context, state) {
        final lastPage = state.lastReadPage;
        final curPage = state.pageByNumber(lastPage);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'متابعة قراءة القرآن',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            Material(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MushafPageReader(initialPage: lastPage),
                  ),
                ),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.menu_book_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              curPage?.headerSurahName ?? 'المصحف الشريف',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'صفحة ${toArabicDigits(lastPage)} • ${curPage?.headerJuzHizb ?? 'الجزء 1'}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_left_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────── فئات مميزة ───────────────────────────
class _FeaturedCategories extends StatelessWidget {
  const _FeaturedCategories();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AdhkarCubit, AdhkarState>(
      builder: (context, state) {
        final categories = state.categoriesOf(AdhkarKind.azkar).take(6).toList();
        if (categories.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'فئات الأذكار',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 92,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final cat = categories[i];
                  return _CategoryChip(category: cat);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final AdhkarCategory category;
  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DhikrDetailPage(category: category),
          ),
        ),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 140,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Icon(resolveIcon(category.icon), color: theme.colorScheme.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
