import 'package:azkar/App/detals/widget/circular_counter.dart';
import 'package:azkar/App/detals/widget/navigation_buttons.dart';
import 'package:azkar/App/detals/widget/progress_bar.dart';
import 'package:azkar/App/detals/widget/zikr_card.dart';
import 'package:azkar/App/detals/widget/zikr_item.dart';
import 'package:azkar/core/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

// ─── Screen ───────────────────────────────────────────────────────────────────

class ZikrDetailScreen extends StatefulWidget {
  const ZikrDetailScreen({super.key});

  @override
  State<ZikrDetailScreen> createState() => _ZikrDetailScreenState();
}

class _ZikrDetailScreenState extends State<ZikrDetailScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _count = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  ZikrItem get _current => zikrList[_currentIndex];
  double get _progress => _current.maxCount == 1
      ? (_count >= 1 ? 1.0 : 0.0)
      : _count / _current.maxCount;
  bool get _completed => _count >= _current.maxCount;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onCounterTap() {
    if (_completed) return;
    HapticFeedback.lightImpact();
    _pulseController.forward().then((_) => _pulseController.reverse());
    setState(() => _count++);
  }

  void _goNext() {
    if (_currentIndex < zikrList.length - 1) {
      setState(() {
        _currentIndex++;
        _count = 0;
      });
    }
  }

  void _goPrev() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _count = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          title: Text("أذكاري", style: TextStyle(color: AppColor.primary)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, color: AppColor.primary),
            ),
          ],
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu, color: AppColor.primary),
          ),
          elevation: 1,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              children: [
                // ── Progress Bar ──
                ProgressBar(
                  current: _currentIndex + 1,
                  total: zikrList.length,
                  progress:
                      (_currentIndex + (_completed ? 1 : _progress)) /
                      zikrList.length,
                ),
                const SizedBox(height: 32),

                // ── Zikr Content Card ──
                ZikrCard(item: _current),
                const SizedBox(height: 32),

                // ── Counter Area ──
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Circular counter button
                      CircularCounter(
                        count: _count,
                        maxCount: _current.maxCount,
                        progress: _progress,
                        completed: _completed,
                        pulseAnim: _pulseAnim,
                        onTap: _onCounterTap,
                      ),
                    ],
                  ),
                ),

                // ── Navigation Buttons ──
                NavigationButtons(
                  canGoPrev: _currentIndex > 0,
                  canGoNext: _currentIndex < zikrList.length - 1,
                  onPrev: _goPrev,
                  onNext: _goNext,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double progress;
  const ArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 7.0;
    const startAngle = -math.pi / 2;

    // Track
    final trackPaint = Paint()
      ..color = const Color(0xFFE6E8EA)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF3E65FF), Color(0xFF0A47EE)],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(ArcPainter old) => old.progress != progress;
}
