// ─── Data ─────────────────────────────────────────────────────────────────────
import 'package:azkar/App/All_Azkar/widgets/icon_btn.dart';
import 'package:azkar/core/colors/colors.dart';
import 'package:flutter/material.dart';

class AzkarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AzkarAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColor.background,
        border: Border(bottom: BorderSide(color: Color(0xFFE6E8EA), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconBtn(icon: Icons.menu_rounded),
          const Text(
            'الأذكار',
            style: TextStyle(
              color: Color(0xFF0A47EE),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          IconBtn(icon: Icons.search_rounded),
        ],
      ),
    );
  }
}
