import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_Provider.dart'; // Ajusta la ruta según tu proyecto

class TextFormFieldTheme {
  TextFormFieldTheme._();

  static InputDecoration customInputDecoration({
    required String? labelText,
    required IconData? icon,
    required BuildContext context,
  }) {
    // Obtén el estado de modo oscuro desde el ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    var isDark = themeProvider.isDarkMode;

    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(
        icon,
        color: isDark ? Colors.white : const Color(0xFF0057E5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide(
          color: isDark
              ? Colors.white38
              : Colors.black38, // Ajusta el color para el estado no enfocado
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide(
          color: isDark
              ? Colors.white
              : Colors.black, // Color del borde cuando está enfocado
          width: 1.0,
        ),
      ),
      floatingLabelStyle: TextStyle(
        color: isDark
            ? Colors.white
            : Colors.black, // Color del label cuando está flotando
      ),
      prefixIconColor: isDark ? Colors.amber[300] : Colors.amber,
    );
  }
}
