import 'package:flutter/material.dart';

class RegisterInput extends StatelessWidget {
  final String hintText;

  const RegisterInput({
    super.key,
    required TextEditingController nombreController,
    required this.hintText,
  }) : _nombreController = nombreController;

  final TextEditingController _nombreController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: TextFormField(
        controller: _nombreController,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(8.0),
        ),
      ),
    );
  }
}
