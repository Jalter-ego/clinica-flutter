import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.textColor,
    required this.backgroundColor,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 16,
        color: textColor,
      ),
      label: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
