// ─── Data ─────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'الأذكار',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Color(0xFF191C1E),
            fontSize: 30,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'اختر من بين مجموعة متنوعة من الأذكار والأدعية المأثورة عن النبي ﷺ',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Color(0xFF414755),
            fontSize: 16,
            height: 1.625,
          ),
        ),
      ],
    );
  }
}
