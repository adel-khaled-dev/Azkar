import 'package:flutter/material.dart';

class IconBtn extends StatelessWidget {
  final IconData icon;
  const IconBtn({super.key, required this.icon});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {},
    child: SizedBox(
      width: 40,
      height: 40,
      child: Icon(icon, color: const Color(0xFF0A47EE), size: 24),
    ),
  );
}
