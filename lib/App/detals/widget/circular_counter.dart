import 'package:azkar/App/detals/pages/detals.dart';
import 'package:flutter/material.dart';

class CircularCounter extends StatelessWidget {
  final int count;
  final int maxCount;
  final double progress;
  final bool completed;
  final Animation<double> pulseAnim;
  final VoidCallback onTap;

  const CircularCounter({
    super.key,
    required this.count,
    required this.maxCount,
    required this.progress,
    required this.completed,
    required this.pulseAnim,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: pulseAnim,
        builder: (context, child) =>
            Transform.scale(scale: pulseAnim.value, child: child),
        child: SizedBox(
          width: 176,
          height: 176,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: 176,
                height: 176,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFF0A47EE).withValues(alpha: 0.05),
                    width: 6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0A47EE).withValues(alpha: 0.3),
                      blurRadius: 40,
                      spreadRadius: -10,
                    ),
                  ],
                ),
              ),
              // Arc painter
              CustomPaint(
                size: const Size(164, 164),
                painter: ArcPainter(progress: progress),
              ),
              // Center content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: Text(
                      completed ? '✓' : '$count',
                      key: ValueKey(completed ? 'done' : count),
                      style: TextStyle(
                        color: const Color(0xFF0A47EE),
                        fontSize: 60,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'sans-serif',
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'من $maxCount',
                    style: TextStyle(
                      color: const Color(0xFF414755).withValues(alpha: 0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
