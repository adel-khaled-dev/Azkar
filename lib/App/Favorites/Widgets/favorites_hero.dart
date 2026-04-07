import 'package:flutter/material.dart';

class FavoritesHero extends StatelessWidget {
  const FavoritesHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 172,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A47EE), Color(0xFF3E65FF)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Book icon
          const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          // Title
          const Text(
            'المفضلة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.33,
            ),
          ),
          const SizedBox(height: 8),
          // Subtitle
          Text(
            'أذكارك المحفوظة في مكان واحد',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: FontWeight.w300,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }
}
