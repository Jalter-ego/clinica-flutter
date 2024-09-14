//lib/servicios/autenticacion_Services.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/utils/constantes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AutenticacionServices {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> loginUsuario({
    required BuildContext context,
    required String ci,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Constantes.uri}/usuarios/login'),
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

  Future<String?> obtenerUsuario() async {
    try {
      String? token = await storage.read(key: 'token');

      if (token != null) {
        final response = await http.get(
          Uri.parse('${Constantes.uri}/usuarios/obtenerUsuario'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['nombre'];
        } else {
          print('Error al obtener el usuario: ${response.reasonPhrase}');
          return null;
        }
      }
      return null;
    } catch (e) {
      print('Error al obtener el usuario: $e');
      return null;
    }
  }
}
