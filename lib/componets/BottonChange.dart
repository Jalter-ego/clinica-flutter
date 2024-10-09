import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_Provider.dart';

class BottonChange extends StatelessWidget {
  final Color colorBack;
  final Color colorFont;
  final String textTile;
  final VoidCallback onPressed;

  const BottonChange({
    super.key,
    required this.colorBack,
    required this.colorFont,
    required this.textTile,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var isDark = themeProvider.isDarkMode;
    return SizedBox(
      width: 300,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : colorBack,
            side: BorderSide.none,
            shape: const StadiumBorder()),
        child: Text(
          textTile,
          style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.black : colorFont,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
