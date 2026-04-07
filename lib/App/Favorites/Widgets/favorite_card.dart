import 'package:azkar/App/Favorites/Widgets/favoriteitem.dart';
import 'package:azkar/App/Favorites/Widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FavoriteCard extends StatelessWidget {
  final FavoriteItem item;
  final VoidCallback onCountChanged;
  final VoidCallback onFavoriteToggled;

  const FavoriteCard({super.key, 
    required this.item,
    required this.onCountChanged,
    required this.onFavoriteToggled,
  });

  void _increment() {
    if (item.count < item.maxCount) {
      item.count++;
      HapticFeedback.lightImpact();
      onCountChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool completed = item.count >= item.maxCount;

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Row 1: Category badge + Bookmark icon ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bookmark / favorite toggle
              GestureDetector(
                onTap: onFavoriteToggled,
                child: Icon(
                  item.isFavorited
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: const Color(0xFF0A47EE),
                  size: 22,
                ),
              ),
              // Category badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E8EA),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  item.category,
                  style: const TextStyle(
                    color: Color(0xFF414755),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Row 2: Arabic text ──
          Text(
            item.arabicText,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF191C1E),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.8,
            ),
          ),

          const SizedBox(height: 24),

          // ── Row 3: Counter + action buttons ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Share + Copy buttons
              Row(
                children: [
                  RoundButton(icon: Icons.share_rounded, onTap: () {}),
                  const SizedBox(width: 8),
                  RoundButton(icon: Icons.copy_rounded, onTap: () {}),
                ],
              ),

              // Counter section
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Source label
                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      item.source,
                      style: const TextStyle(
                        color: Color(0xFF006590),
                        fontSize: 12,
                        height: 1.33,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Counter controls
                  Row(
                    children: [
                      // Count display
                      Text(
                        '${item.count}',
                        style: const TextStyle(
                          color: Color(0xFF0A47EE),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'sans-serif',
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Tap-to-count button
                      GestureDetector(
                        onTap: _increment,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: completed
                                ? const Color(0xFF3E65FF).withValues(alpha: 0.2)
                                : Colors.transparent,
                            border: completed
                                ? null
                                : Border.all(
                                    color: const Color(0xFF3E65FF),
                                    width: 2,
                                  ),
                            shape: BoxShape.circle,
                          ),
                          child: completed
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Color(0xFF0A47EE),
                                  size: 16,
                                )
                              : const Icon(
                                  Icons.add_rounded,
                                  color: Color(0xFF0A47EE),
                                  size: 16,
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
