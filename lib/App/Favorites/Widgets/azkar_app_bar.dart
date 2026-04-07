import 'package:azkar/App/All_Azkar/widgets/icon_btn.dart';
import 'package:flutter/material.dart';

class AzkarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AzkarAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 64,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F6FA),
          border: Border(
            bottom: BorderSide(color: Color(0xFFE6E8EA), width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconBtn(icon: Icons.menu_rounded),
            const Text(
              'المفضلة',
              style: TextStyle(
                color: Color(0xFF0A47EE),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconBtn(icon: Icons.search_rounded),
          ],
        ),
      ),
    );
  }
}
