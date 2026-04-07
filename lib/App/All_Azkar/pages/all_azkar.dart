// ─── Data ─────────────────────────────────────────────────────────────────────
import 'package:azkar/App/All_Azkar/widgets/azkar_banner.dart';
import 'package:azkar/App/All_Azkar/widgets/azkar_category.dart';
import 'package:azkar/App/All_Azkar/widgets/category_card.dart';
import 'package:azkar/App/All_Azkar/widgets/hero_section.dart';
import 'package:azkar/core/colors/colors.dart';
import 'package:flutter/material.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────
class AzkarCategoriesScreen extends StatelessWidget {
  const AzkarCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("أذكاري", style: TextStyle(color: AppColor.primary)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, color: AppColor.primary),
            ),
          ],
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu, color: AppColor.primary),
          ),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Hero ──
              const HeroSection(),
              const SizedBox(height: 24),
              // ── Blue Banner ──
              const AzkarBanner(),
              const SizedBox(height: 16),
              // ── Category List ──
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) =>
                    CategoryCard(category: categories[i]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
