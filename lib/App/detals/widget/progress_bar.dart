import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final double progress;

  const ProgressBar({super.key, 
    required this.current,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // "X من Y"
              Opacity(
                opacity: 0.6,
                child: Text(
                  '$current من $total',
                  style: const TextStyle(
                    color: Color(0xFF414755),
                    fontSize: 12,
                  ),
                ),
              ),
              // Percentage
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  color: Color(0xFF0A47EE),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'sans-serif',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE6E8EA),
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                height: 6,
                width: constraints.maxWidth * progress,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3E65FF), Color(0xFF0A47EE)],
                  ),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
