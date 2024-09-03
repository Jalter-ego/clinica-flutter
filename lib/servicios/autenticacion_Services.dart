//lib/servicios/autenticacion_Services.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/utils/constantes.dart';
import 'package:http/http.dart' as http;

class AutenticacionServices {
  Future<Map<String, dynamic>?> loginUsuario({
    required BuildContext context,
    required String ci,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Constantes.uri}/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'ci': ci, 'password': password}),
      );

      print('Respuesta del servidor: ${response.body}'); // Depuración

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      return null;
    }
  }
}
