import 'package:flutter/material.dart';

class DailyQuranBanner extends StatelessWidget {
  const DailyQuranBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF70C7FF).withOpacity(0.2),
            const Color(0xFF3E65FF).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Arrow icon
          const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF717786),
            size: 16,
          ),
          // Quran info
          Row(
            children: [
              // Play button
              Container(
                width: 46,
                height: 40,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF0A47EE),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    'القرآن اليومي',
                    style: TextStyle(
                      color: Color(0xFF191C1E),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'سورة الكهف • الجزء ١٥',
                    style: TextStyle(color: Color(0xFF414755), fontSize: 10),
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
