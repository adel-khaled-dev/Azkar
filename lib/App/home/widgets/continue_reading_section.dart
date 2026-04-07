import 'package:azkar/App/home/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class ContinueReadingSection extends StatelessWidget {
  const ContinueReadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {},
              child: const Text(
                'عرض الكل',
                style: TextStyle(
                  color: Color(0xFF0A47EE),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Text(
              'آخر قراءة',
              style: TextStyle(
                color: Color(0xFF191C1E),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 24,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Play button
              Container(
                width: 43,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A47EE),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0A47EE).withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Category badge + icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF006590,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.menu_book_rounded,
                            color: Color(0xFF006590),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'قرآن',
                          style: TextStyle(
                            color: Color(0xFF717786),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    const Text(
                      'سورة البقرة',
                      style: TextStyle(
                        color: Color(0xFF191C1E),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Subtitle
                    const Text(
                      'الآية ٢٥٥ - آية الكرسي',
                      style: TextStyle(color: Color(0xFF414755), fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    // Progress
                    ProgressBar(progress: 0.65),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
