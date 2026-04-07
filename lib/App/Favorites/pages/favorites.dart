import 'package:azkar/App/Favorites/Widgets/favorite_card.dart';
import 'package:azkar/App/Favorites/Widgets/favoriteitem.dart';
import 'package:azkar/App/Favorites/Widgets/favorites_hero.dart';
import 'package:azkar/core/colors/colors.dart';
import 'package:flutter/material.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<FavoriteItem> _items = [
    FavoriteItem(
      category: 'أذكار الصباح',
      arabicText:
          'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      source: 'رواه مسلم',
      count: 0,
      maxCount: 1,
    ),
    FavoriteItem(
      category: 'دعاء',
      arabicText:
          'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ',
      source: 'رواه البخاري',
      count: 2,
      maxCount: 3,
    ),
    FavoriteItem(
      category: 'أذكار المساء',
      arabicText:
          'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      source: 'رواه أبو داود',
      count: 1,
      maxCount: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("المفضلة", style: TextStyle(color: AppColor.primary)),
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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Hero ──
              const FavoritesHero(),
              const SizedBox(height: 32),
              // ── List ──
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 24),
                itemBuilder: (context, i) => FavoriteCard(
                  item: _items[i],
                  onCountChanged: () => setState(() {}),
                  onFavoriteToggled: () => setState(() {
                    _items[i].isFavorited = !_items[i].isFavorited;
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
