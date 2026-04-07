import 'package:azkar/App/detals/widget/zikr_item.dart';
import 'package:flutter/material.dart';

class ZikrCard extends StatelessWidget {
  final ZikrItem item;
  const ZikrCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top row: bookmark icon + category badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bookmark
              Icon(
                Icons.bookmark_border_rounded,
                color: const Color(0xFF414755).withValues(alpha: 0.4),
                size: 22,
              ),
              // Category pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E8EA).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  item.category,
                  style: const TextStyle(
                    color: Color(0xFF006590),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Arabic text
          Text(
            item.arabicText,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF191C1E),
              fontSize: 22,
              fontWeight: FontWeight.w500,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 20),
          // Divider with right border accent
          Container(
            padding: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Color(0x330A47EE),
                  width: 2,
                ),
              ),
            ),
            child: Text(
              item.translation,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: const Color(0xFF414755).withOpacity(0.7),
                fontSize: 14,
                height: 1.62,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
