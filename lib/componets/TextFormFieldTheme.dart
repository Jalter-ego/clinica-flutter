import 'package:flutter/material.dart';

class TextFormFieldTheme {
  TextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
      border: const OutlineInputBorder(),
      prefixIconColor: Colors.amber[200],
      floatingLabelStyle: TextStyle(color: Colors.amber[200]),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
              width: 2, color: Color.fromARGB(255, 240, 212, 129))));
}
