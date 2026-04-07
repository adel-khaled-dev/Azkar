import 'package:flutter/material.dart';

class MorningAzkarCard extends StatelessWidget {
  const MorningAzkarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Decorative bg icon
          Positioned(
            left: -15,
            bottom: -15,
            child: Opacity(
              opacity: 0.05,
              child: const Icon(
                Icons.wb_sunny_rounded,
                size: 88,
                color: Color(0xFF191C1E),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // icon badge
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.wb_sunny_rounded,
                        color: Color(0xFFF97316),
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'أذكار الصباح',
                      style: TextStyle(
                        color: Color(0xFF191C1E),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '٣٣ ذكراً • ٥ دقائق',
                      style: TextStyle(color: Color(0xFF414755), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
