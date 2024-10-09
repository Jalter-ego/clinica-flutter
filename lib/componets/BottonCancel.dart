import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_Provider.dart';

class BottonCancel extends StatelessWidget {
  final Color colorFont;
  final String textTile;

  const BottonCancel({
    super.key,
    required this.colorFont,
    required this.textTile,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var isDark = themeProvider.isDarkMode;
    return SizedBox(
      width: 300,
      height: 40,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: isDark ? Colors.white : colorFont,
          backgroundColor:
              isDark ? Colors.white : Colors.transparent, // Color del texto
          side: BorderSide(color: colorFont),
          elevation: 0,
        ),
        child: Text(
          textTile,
          style: TextStyle(
              fontSize: 14, color: colorFont, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
