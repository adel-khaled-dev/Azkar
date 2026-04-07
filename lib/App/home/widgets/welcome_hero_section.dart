import 'package:azkar/core/colors/colors.dart';
import 'package:flutter/material.dart';

class WelcomeHeroSection extends StatelessWidget {
  const WelcomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 166,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.primary, Color(0xFF3E65FF)],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          // Decorative glow
          BackdropFilter(
            filter: ColorFilter.mode(Colors.transparent, BlendMode.srcOver),
          ),
          // Text content
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'السلام عليكم ',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'أهلاً بك 👋',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'لا تنسَ أذكار الصباح',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
