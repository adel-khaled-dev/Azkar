import 'package:azkar/core/theme/app_theme.dart';
import 'package:azkar/features/quran/logic/quran_cubit.dart';
import 'package:azkar/features/quran/models/surah.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// تحويل الأرقام إلى الأرقام العربية المشرقية.
String toArabicDigits(int number) {
  const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  return number.toString().split('').map((c) => digits[int.parse(c)]).join();
}

/// قارئ المصحف الشريف — صفحات كاملة تحاكي المصحف المطبوع (604 صفحة) مع التقليب الأفقي.
class MushafPageReader extends StatefulWidget {
  final int initialPage;

  const MushafPageReader({super.key, this.initialPage = 1});

  @override
  State<MushafPageReader> createState() => _MushafPageReaderState();
}

class _MushafPageReaderState extends State<MushafPageReader> {
  late final PageController _pageController;
  late int _currentPage;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage.clamp(1, 604);
    _pageController = PageController(initialPage: _currentPage - 1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranCubit>().saveLastReadPage(_currentPage);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    final pageNum = index + 1;
    setState(() => _currentPage = pageNum);
    context.read<QuranCubit>().saveLastReadPage(pageNum);
  }

  void _jumpToPage(int page) {
    final p = page.clamp(1, 604);
    _pageController.jumpToPage(p - 1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cubit = context.watch<QuranCubit>();
    final state = cubit.state;

    if (state.status == QuranStatus.loading || state.mushafPages.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final curPageObj = cubit.state.pageByNumber(_currentPage);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0C120F) : const Color(0xFFFAF7F0),
      body: SafeArea(
        child: Stack(
          children: [
            // عارض صفحات المصحف بتقليب الصفحات
            GestureDetector(
              onTap: () => setState(() => _showControls = !_showControls),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: state.mushafPages.length,
                itemBuilder: (context, index) {
                  final page = state.mushafPages[index];
                  return _MushafPageView(page: page);
                },
              ),
            ),

            // شريط التحكم العلوي
            if (_showControls)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.surfaceDark : Colors.white).withValues(alpha: 0.95),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'رجوع',
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              curPageObj?.headerSurahName ?? 'القرآن الكريم',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                            ),
                            Text(
                              curPageObj?.headerJuzHizb ?? '',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_add_rounded),
                        tooltip: 'حفظ علامة القراءة',
                        onPressed: () {
                          context.read<QuranCubit>().saveLastReadPage(_currentPage);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم حفظ علامة القراءة عند الصفحة ${toArabicDigits(_currentPage)}'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.format_list_bulleted_rounded),
                        tooltip: 'فهرس السور',
                        onPressed: () => _showSurahIndex(context, state.surahs),
                      ),
                    ],
                  ),
                ),
              ),

            // شريط التحكم السفلي
            if (_showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.surfaceDark : Colors.white).withValues(alpha: 0.95),
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'صفحة ${toArabicDigits(_currentPage)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'من ${toArabicDigits(604)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _currentPage.toDouble(),
                        min: 1,
                        max: 604,
                        divisions: 603,
                        activeColor: theme.colorScheme.primary,
                        onChanged: (val) => _jumpToPage(val.round()),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSurahIndex(BuildContext context, List<Surah> surahs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'فهرس سور القرآن الكريم',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: surahs.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (subCtx, i) {
                    final surah = surahs[i];
                    final page = context.read<QuranCubit>().state.pageForSurah(surah.number);
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      leading: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${surah.number}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      title: Text(
                        'سورة ${surah.name}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text('${surah.type} • ${surah.ayahCount} آية'),
                      trailing: Text(
                        'صفحة ${toArabicDigits(page)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(subCtx).pop();
                        _jumpToPage(page);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// عرض الصفحة الفردية من المصحف داخل الإطار المزخرف.
class _MushafPageView extends StatelessWidget {
  final MushafPage page;

  const _MushafPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF141C18) : const Color(0xFFFFFDF8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? const Color(0xFF283830) : const Color(0xFFEADFC9),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ترويسة أعلى الصفحة (اسم السورة والجزء)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                children: [
                  Text(
                    page.headerSurahName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    page.headerJuzHizb,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              color: isDark ? const Color(0xFF223028) : const Color(0xFFEFE8D8),
              thickness: 1,
              height: 1,
            ),

            // محتوى الآيات مع إطارات السور والبسملة
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Center(
                  child: SingleChildScrollView(
                    child: _PageVersesRenderer(page: page),
                  ),
                ),
              ),
            ),

            Divider(
              color: isDark ? const Color(0xFF223028) : const Color(0xFFEFE8D8),
              thickness: 1,
              height: 1,
            ),

            // رقم الصفحة في الأسفل
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1C2722)
                      : const Color(0xFFF4ECDB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  toArabicDigits(page.pageNumber),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFF8AE0C6) : AppColors.primaryDeep,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// يرتب الآيات وبانر بداية السور والبسملة بتصميم متصل وجميل.
class _PageVersesRenderer extends StatelessWidget {
  final MushafPage page;

  const _PageVersesRenderer({required this.page});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final widgets = <Widget>[];
    final currentAyahSpans = <InlineSpan>[];

    void flushSpans() {
      if (currentAyahSpans.isEmpty) return;
      widgets.add(
        Text.rich(
          TextSpan(children: List.from(currentAyahSpans)),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: page.pageNumber <= 2 ? 22 : 19.5,
            height: page.pageNumber <= 2 ? 2.4 : 2.1,
            fontFamily: 'serif',
            color: isDark ? const Color(0xFFEDF6F1) : const Color(0xFF1C2822),
          ),
        ),
      );
      currentAyahSpans.clear();
    }

    for (final ayah in page.ayahs) {
      if (ayah.isFirstAyahInSurah) {
        flushSpans();
        // بانر اسم السورة
        widgets.add(_SurahBanner(
          surahName: ayah.surahName,
          surahType: ayah.surahType,
        ));

        // البسملة (عدا سورة الفاتحة 1 والتوبة 9)
        if (ayah.surahNumber != 1 && ayah.surahNumber != 9) {
          widgets.add(const _BismillahHeader());
        }
      }

      currentAyahSpans.add(TextSpan(text: '${ayah.text} '));
      currentAyahSpans.add(
        TextSpan(
          text: '﴿${toArabicDigits(ayah.ayahNumber)}﴾ ',
          style: TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      );
    }

    flushSpans();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }
}

/// بانر ترويسة اسم السورة المزخرف.
class _SurahBanner extends StatelessWidget {
  final String surahName;
  final String surahType;

  const _SurahBanner({required this.surahName, required this.surahType});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2C24) : const Color(0xFFF3EBD8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_rounded, size: 14, color: AppColors.gold),
          const SizedBox(width: 8),
          Text(
            'سُورَةُ $surahName ($surahType)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? const Color(0xFFD4EAE0) : AppColors.primaryDeep,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.star_rounded, size: 14, color: AppColors.gold),
        ],
      ),
    );
  }
}

/// كتابة البسملة بخط وتنسيق جمالي.
class _BismillahHeader extends StatelessWidget {
  const _BismillahHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'serif',
          color: isDark ? const Color(0xFFB0D5C3) : const Color(0xFF2B4E40),
        ),
      ),
    );
  }
}
