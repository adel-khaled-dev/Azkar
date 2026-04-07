import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final bool canGoPrev;
  final bool canGoNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const NavigationButtons({super.key, 
    required this.canGoPrev,
    required this.canGoNext,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          // Previous button
          Expanded(
            child: GestureDetector(
              onTap: canGoPrev ? onPrev : null,
              child: AnimatedOpacity(
                opacity: canGoPrev ? 1.0 : 0.4,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E8EA),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'السابق',
                        style: TextStyle(
                          color: Color(0xFF414755),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF414755),
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Next button
          Expanded(
            child: GestureDetector(
              onTap: canGoNext ? onNext : null,
              child: AnimatedOpacity(
                opacity: canGoNext ? 1.0 : 0.4,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A47EE),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0A47EE).withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: const Color(0xFF0A47EE).withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'التالي',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}