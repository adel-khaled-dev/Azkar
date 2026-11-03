import 'package:azkar/core/theme/app_theme.dart';
import 'package:azkar/core/utils/icon_resolver.dart';
import 'package:azkar/features/adhkar/logic/adhkar_cubit.dart';
import 'package:azkar/features/adhkar/models/adhkar_models.dart';
import 'package:azkar/features/adhkar/presentation/dhikr_detail_page.dart';
import 'package:azkar/features/adhkar/presentation/dua_reader_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة فئات الأذكار أو الأدعية.
class CategoriesPage extends StatelessWidget {
  final AdhkarKind kind;

  const CategoriesPage({super.key, required this.kind});

  bool get _isAzkar => kind == AdhkarKind.azkar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAzkar ? 'الأذكار' : 'الأدعية'),
      ),
      body: BlocBuilder<AdhkarCubit, AdhkarState>(
        builder: (context, state) {
          if (state.status == AdhkarStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == AdhkarStatus.error) {
            return _Message(
              icon: Icons.error_outline_rounded,
              title: 'تعذّر تحميل البيانات',
              subtitle: 'اسحب للأسفل لإعادة المحاولة',
            );
          }

          final categories = state.categoriesOf(kind);
          if (categories.isEmpty) {
            return const _Message(
              icon: Icons.inbox_rounded,
              title: 'لا توجد بيانات',
              subtitle: 'لم يتم العثور على أي فئة',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            itemCount: categories.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              if (i == 0) {
                return _Header(
                  title: _isAzkar ? 'الأذكار اليومية' : 'الأدعية المأثورة',
                  subtitle: _isAzkar
                      ? 'أذكار مأثورة عن النبي ﷺ في كل المواقف'
                      : 'أدعية من القرآن والسنة النبوية',
                  count: categories.length,
                );
              }
              final category = categories[i - 1];
              return _CategoryTile(
                category: category,
                onTap: () {
                  final page = _isAzkar
                      ? DhikrDetailPage(category: category)
                      : DuaReaderPage(category: category);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => page),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final int count;

  const _Header({
    required this.title,
    required this.subtitle,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$count فئة',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final AdhkarCategory category;
  final VoidCallback onTap;

  const _CategoryTile({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  resolveIcon(category.icon),
                  color: theme.colorScheme.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${category.itemCount} ${category.itemCount == 1 ? 'ذكر' : 'أذكار'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_left_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _Message({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
