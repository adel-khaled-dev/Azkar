import 'package:azkar/App/home/widgets/continue_reading_section.dart';
import 'package:azkar/App/home/widgets/discover_section.dart';
import 'package:azkar/App/home/widgets/quick_access_section.dart';
import 'package:azkar/App/home/widgets/welcome_hero_section.dart';
import 'package:azkar/core/colors/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                WelcomeHeroSection(),
                SizedBox(height: 30),
                ContinueReadingSection(),
                SizedBox(height: 30),
                QuickAccessSection(),
                SizedBox(height: 30),
                DiscoverSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
