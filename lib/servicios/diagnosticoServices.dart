import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constantes.dart';

class DiagnosticoServices {
  Future<List<Map<String, dynamic>>> getDiagnosticosPorUsuario(int usuarioId) async {
    final response = await http.get(Uri.parse('${Constantes.uri}/diagnosticos/usuario/$usuarioId'));

    if (response.statusCode == 200) {
      List<dynamic> diagnosticos = json.decode(response.body);

      return diagnosticos.map((d) {
        return {
          'id': d['id'],
          'consulta_id': d['consulta_id'],
          'descripcion': d['descripcion'],
          'tipo_diagnostico': d['tipo_diagnostico'],
          'fecha': d['fecha'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load diagnosticos');
    }
  }

  Future<List<Map<String, dynamic>>> getDiagnosticos() async {
    final response =
        await http.get(Uri.parse('${Constantes.uri}/diagnosticos/listar'));

    if (response.statusCode == 200) {
      List<dynamic> diagnosticos = json.decode(response.body);
      return diagnosticos.map((d) {
        return {
          'id': d['id'],
          'consulta_id': d['consulta_id'],
          'descripcion': d['descripcion'],
          'tipo_diagnostico': d['tipo_diagnostico'],
          'fecha': d['fecha'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load diagnósticos');
    }
  }
   Future<List<Map<String, dynamic>>> getDiagnosticosPorConsulta(int consultaId) async {
    final response = await http.get(Uri.parse('${Constantes.uri}/diagnosticos/consulta/$consultaId'));

    if (response.statusCode == 200) {
      List<dynamic> diagnosticos = json.decode(response.body);
      return diagnosticos.map((d) {
        return {
          'id': d['id'],
          'consulta_id': d['consulta_id'],
          'descripcion': d['descripcion'],
          'tipo_diagnostico': d['tipo_diagnostico'],
          'fecha': d['fecha'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load diagnosticos for consulta');
    }
  }
  Future<bool> crearDiagnostico({
    required int consultaId,
    required String descripcion,
    required String tipoDiagnostico,
  }) async {
    final url = Uri.parse('${Constantes.uri}/diagnosticos/crear');  // URL del servicio

    // Cuerpo de la solicitud en formato JSON
    final Map<String, dynamic> body = {
      "consulta_id": consultaId,
      "descripcion": descripcion,
      "tipo_diagnostico": tipoDiagnostico,

    };

    try {
      // Realizar la solicitud POST
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',  // Especificamos que es JSON
        },
        body: json.encode(body),  // Convertimos el mapa a JSON
      );

      // Verificar si la respuesta fue exitosa (status 200)
      if (response.statusCode == 200) {
        return true;  // Diagnóstico creado exitosamente
      } else {
        print('Error al crear el diagnóstico: ${response.body}');
        return false;  // Error al crear diagnóstico
      }
    } catch (e) {
      print('Excepción al crear diagnóstico: $e');
      return false;  // Excepción al realizar la solicitud
    }
  }
}
