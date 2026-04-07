import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  final int? current;
  final int? total;
  const ProgressBar({
    super.key,
    required this.progress,
    this.current,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(progress * 100).toInt()}% مكتمل',
              style: const TextStyle(color: Color(0xFF717786), fontSize: 10),
            ),
            if (current != null && total != null)
              Text(
                'الصفحة $current من $total',
                style: const TextStyle(color: Color(0xFF717786), fontSize: 10),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 4),
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
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0A47EE), Color(0xFF006590)],
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
