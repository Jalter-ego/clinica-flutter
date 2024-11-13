import 'package:flutter/material.dart';

class IconRounded extends StatelessWidget {
  const IconRounded({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF0057E5),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
