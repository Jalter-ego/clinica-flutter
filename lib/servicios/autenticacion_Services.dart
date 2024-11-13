//lib/servicios/autenticacion_Services.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';

import '../utils/constantes.dart';

class AutenticacionServices {
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

  Future<Map<String, dynamic>?> updateUserName({
    required BuildContext context,
    required String ci,
    required String nombre,
    required String apellidoPaterno,
    required String apellidoMaterno,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${Constantes.uri}/usuarios/editUserName'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'ci': ci,
          'nombre': nombre,
          'apellido_paterno': apellidoPaterno,
          'apellido_materno': apellidoMaterno,
        }),
      );

      print('Respuesta del servidor: ${response.body}');

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

  Future<Map<String, dynamic>?> verifyPassword({
    required BuildContext context,
    required String ci,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Constantes.uri}/usuarios/verifyPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'ci': ci,
          'password': password,
        }),
      );

      print('Respuesta del servidor: ${response.body}');

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

  Future<Map<String, dynamic>?> editUserPassword({
    required BuildContext context,
    required String ci,
    required String newPassword,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${Constantes.uri}/usuarios/editUserPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'ci': ci,
          'newPassword': newPassword,
        }),
      );

      print('Respuesta del servidor: ${response.body}');

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

  Future<List<Map<String, dynamic>>?> obtenerUsuarios(
      BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('${Constantes.uri}/usuarios/obtenerUsuarios'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Decodificar el cuerpo de la respuesta como una lista de mapas
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
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

  Future<void> insertarBitacora({
    required String ip,
    required String ci,
    required DateTime fecha,
    required DateTime hora,
    required String accion,
    required String tabla_afectada,
  }) async {
    final String formattedFecha =
        '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
    final String formattedHora =
        '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}:${hora.second.toString().padLeft(2, '0')}';

    final response = await http.post(
      Uri.parse('${Constantes.uri}/bitacora/insertar'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'ip': ip,
        'ci': ci,
        'fecha': formattedFecha,
        'hora': formattedHora,
        'accion': accion,
        'tabla_afectada': tabla_afectada,
      }),
    );

    if (response.statusCode == 200) {
      print('Bitacora insertada: ${response.body}');
    } else {
      print('Error al insertar la bitacora: ${response.body}');
      throw Exception('Error al insertar la bitacora');
    }
  }

  Future<String> obtenerIP() async {
    final info = NetworkInfo();
    var wifiIP = await info.getWifiIP();
    return wifiIP ?? 'IP no disponible';
  }
}
