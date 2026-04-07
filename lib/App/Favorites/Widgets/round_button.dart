import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const RoundButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFFECEEF0),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF006590), size: 18),
      ),
    );
  }
}
