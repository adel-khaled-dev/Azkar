
import 'package:azkar/App/home/widgets/discover_card.dart';
import 'package:azkar/App/home/widgets/discover_card_data.dart';
import 'package:flutter/material.dart';

class DiscoverSection extends StatelessWidget {
  const DiscoverSection({super.key});

  static const _cards = [
    DiscoverCardData(
      title: 'أدعية الأنبياء',
      category: 'دعاء',
      categoryColor: Color(0xFF0A47EE),
      categoryBg: Color(0x0D0A47EE),
    ),
    DiscoverCardData(
      title: 'أذكار بعد الصلاة',
      category: 'ذكر',
      categoryColor: Color(0xFF006590),
      categoryBg: Color(0x0D006590),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'اكتشف',
          style: TextStyle(
            color: Color(0xFF191C1E),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 207,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _cards.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, i) => DiscoverCard(data: _cards[i]),
          ),
        ),
      ],
    );
  }
}
