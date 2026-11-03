import 'package:azkar/core/theme/app_theme.dart';
import 'package:azkar/core/widgets/favorite_button.dart';
import 'package:azkar/features/quran/logic/quran_cubit.dart';
import 'package:azkar/features/quran/models/surah.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة قراءة سورة كاملة.
class SurahPage extends StatefulWidget {
  final int surahNumber;

  const SurahPage({super.key, required this.surahNumber});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  @override
  void initState() {
    super.initState();
    // حفظ موضع القراءة (على مستوى السورة).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranCubit>().saveLastRead(widget.surahNumber, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          final surah = state.surahByNumber(widget.surahNumber);
          if (surah == null) {
            return const Center(child: CircularProgressIndicator());
          }
          // البسملة تظهر مرة واحدة فقط كأول آية في القائمة
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            children: [
              _SurahHeader(surah: surah),
              const SizedBox(height: 8),
              for (final ayah in surah.ayahs)
                _AyahTile(surah: surah, ayah: ayah),
            ],
          );
        },
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  final Surah surah;
  const _SurahHeader({required this.surah});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${surah.number}',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'سورة ${surah.name}',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          '${surah.type} • ${surah.ayahCount} آية',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        // ✅ البسملة لا تُعرض هنا — تظهر مرة واحدة كأول آية في القائمة
        const SizedBox(height: 16),
        Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      ],
    );
  }
}

class _AyahTile extends StatelessWidget {
  final Surah surah;
  final Ayah ayah;
  const _AyahTile({required this.surah, required this.ayah});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FavoriteButton(
            compact: true,
            kind: 'ayah',
            id: '${surah.number}_${ayah.number}',
            title: 'سورة ${surah.name} • الآية ${ayah.number}',
            subtitle: ayah.text,
            icon: 'menu_book',
            surahNumber: surah.number,
            ayahNumber: ayah.number,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ayah.text,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.titleMedium?.copyWith(
                    height: 2.0,
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${ayah.number}',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Divider(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
