// ─── Data ─────────────────────────────────────────────────────────────────────

import 'package:azkar/App/All_Azkar/widgets/azkar_category.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final AzkarCategory category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 88,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Arrow chevron (left in RTL = trailing)
            const Icon(
              Icons.chevron_left_rounded,
              color: Color(0xFFC1C6D7),
              size: 20,
            ),
            const Spacer(),
            // Title + count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category.title,
                  style: const TextStyle(
                    color: Color(0xFF191C1E),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
                Text(
                  category.count,
                  style: const TextStyle(
                    color: Color(0xFF414755),
                    fontSize: 12,
                    height: 1.33,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Icon badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF006590).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category.icon,
                color: const Color(0xFF006590),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
