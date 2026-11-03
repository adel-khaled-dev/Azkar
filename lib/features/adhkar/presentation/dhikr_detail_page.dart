import 'dart:math' as math;

import 'package:azkar/core/theme/app_theme.dart';
import 'package:azkar/features/adhkar/logic/dhikr_counter_cubit.dart';
import 'package:azkar/features/adhkar/models/adhkar_models.dart';
import 'package:azkar/core/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// صفحة تفاصيل الذكر مع عدّاد التسبيح.
class DhikrDetailPage extends StatelessWidget {
  final AdhkarCategory category;
  final int initialIndex;

  const DhikrDetailPage({
    super.key,
    required this.category,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DhikrCounterCubit()..start(category.items, initialIndex: initialIndex),
      child: _Body(category: category),
    );
  }
}

class _Body extends StatelessWidget {
  final AdhkarCategory category;

  const _Body({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
        actions: [
          BlocBuilder<DhikrCounterCubit, DhikrCounterState>(
            builder: (context, counterState) {
              final item = counterState.current;
              if (item == null) return const SizedBox.shrink();
              return FavoriteButton(
                kind: 'adhkar',
                id: item.id,
                title: item.text,
                subtitle: '${category.title} • ${item.source}',
                icon: category.icon,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<DhikrCounterCubit, DhikrCounterState>(
          builder: (context, state) {
            final item = state.current;
            if (item == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                children: [
                  _ProgressHeader(state: state),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _ZikrCard(item: item, category: category),
                  ),
                  const SizedBox(height: 16),
                  _CounterCircle(state: state),
                  const SizedBox(height: 12),
                  _NavigationButtons(state: state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final DhikrCounterState state;
  const _ProgressHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (state.progress * 100).round();
    return Column(
      children: [
        Row(
          children: [
            Text(
              '${state.currentIndex + 1} من ${state.total}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const Spacer(),
            Text(
              '$percent%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: state.progress,
            minHeight: 6,
            backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}

class _ZikrCard extends StatelessWidget {
  final AdhkarItem item;
  final AdhkarCategory category;

  const _ZikrCard({required this.item, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    category.title,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (item.count > 1)
                  Text(
                    'يكرر ${item.count} مرة',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              item.text,
              textAlign: TextAlign.right,
              style: theme.textTheme.titleLarge?.copyWith(
                height: 1.9,
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
            if (item.translation.isNotEmpty) ...[
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border(
                    right: BorderSide(color: theme.colorScheme.primary, width: 3),
                  ),
                ),
                child: Text(
                  item.translation,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.7,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
            if (item.source.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.source,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: item.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم نسخ الذكر')),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, size: 20),
                    tooltip: 'نسخ',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CounterCircle extends StatelessWidget {
  final DhikrCounterState state;
  const _CounterCircle({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = state.current!;
    final progress = item.count <= 0
        ? 0.0
        : (state.currentCount / item.count).clamp(0.0, 1.0);
    final done = state.isCurrentDone;

    return GestureDetector(
      onTap: () {
        if (done) return;
        HapticFeedback.lightImpact();
        context.read<DhikrCounterCubit>().increment();
      },
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(150, 150),
              painter: _ArcPainter(
                progress: progress,
                trackColor: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                progressColor: theme.colorScheme.primary,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Text(
                    done ? '✓' : '${state.currentCount}',
                    key: ValueKey(done ? 'done' : state.currentCount),
                    style: TextStyle(
                      color: done
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'من ${item.count}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  const _ArcPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const stroke = 8.0;
    const start = -math.pi / 2;

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, track);

    if (progress > 0) {
      final arc = Paint()
        ..shader = SweepGradient(
          colors: [progressColor, progressColor.withValues(alpha: 0.7)],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        2 * math.pi * progress,
        false,
        arc,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.progress != progress ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor;
}

class _NavigationButtons extends StatelessWidget {
  final DhikrCounterState state;
  const _NavigationButtons({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DhikrCounterCubit>();

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: state.currentIndex > 0 ? cubit.previous : null,
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 15),
            label: const Text('السابق'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 2,
          child: FilledButton.icon(
            onPressed: state.isCurrentDone
                ? (state.currentIndex < state.total - 1
                    ? cubit.next
                    : null)
                : cubit.increment,
            icon: Icon(
              state.isCurrentDone
                  ? Icons.arrow_back_ios_rounded
                  : Icons.add_rounded,
              size: 16,
            ),
            label: Text(
              state.isCurrentDone
                  ? (state.currentIndex < state.total - 1 ? 'التالي' : 'انتهى')
                  : 'تسبيح',
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

