import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constantes.dart';

class CitasServices {
  Future<List<Map<String, dynamic>>?> listarCitas({
    required BuildContext context,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${Constantes.uri}/citas/listar'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> citasList = jsonDecode(response.body) as List<dynamic>;

        // Mapeo de la respuesta para ajustarlo al formato requerido
        List<Map<String, dynamic>> citas = citasList.map((cita) {
          return {
            'id': cita['id'],
            'paciente': cita['paciente'],
            'especialista': cita['especialista'],
            'servicio': cita['servicio'],
            'fecha': cita['fecha'],
            'hora': cita['hora'],
            'estado': cita['estado'],
            'comentario': cita['comentario'],
            'tipo_cita': cita['tipo_cita'],
          };
        }).toList();

        return citas;
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
