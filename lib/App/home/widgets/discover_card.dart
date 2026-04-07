import 'package:azkar/App/home/widgets/discover_card_data.dart';
import 'package:flutter/material.dart';

class DiscoverCard extends StatelessWidget {
  final DiscoverCardData data;
  const DiscoverCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Image placeholder
          Container(
            height: 128,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  data.categoryColor.withOpacity(0.15),
                  data.categoryColor.withOpacity(0.3),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.auto_stories_rounded,
                color: data.categoryColor,
                size: 48,
              ),
            ),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: data.categoryBg,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    data.category,
                    style: TextStyle(color: data.categoryColor, fontSize: 10),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Color(0xFF191C1E),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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
