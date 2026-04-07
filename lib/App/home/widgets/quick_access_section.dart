import 'package:azkar/App/home/widgets/daily_quran_banner.dart';
import 'package:azkar/App/home/widgets/morning_azkar_card.dart';
import 'package:azkar/App/home/widgets/small_azkar_card.dart';
import 'package:flutter/material.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'وصول سريع',
          style: TextStyle(
            color: Color(0xFF191C1E),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        // Morning Azkar - Full width
        MorningAzkarCard(),
        const SizedBox(height: 16),
        // 2-column grid row 1
        Row(
          children: [
            Expanded(
              child: SmallAzkarCard(
                label: 'أذكار المساء',
                icon: Icons.nights_stay_rounded,
                iconColor: const Color(0xFF6366F1),
                bgColor: const Color(0xFFEEF2FF),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SmallAzkarCard(
                label: 'أذكار النوم',
                icon: Icons.bedtime_rounded,
                iconColor: const Color(0xFF3B82F6),
                bgColor: const Color(0xFFEFF6FF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 2-column grid row 2
        Row(
          children: [
            Expanded(
              child: SmallAzkarCard(
                label: 'أذكار السفر',
                icon: Icons.flight_rounded,
                iconColor: const Color(0xFFD97706),
                bgColor: const Color(0xFFFFFBEB),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SmallAzkarCard(
                label: 'أدعية الصلاة',
                icon: Icons.mosque_rounded,
                iconColor: const Color(0xFF10B981),
                bgColor: const Color(0xFFECFDF5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Daily Quran banner
        DailyQuranBanner(),
      ],
    );
  }
}
