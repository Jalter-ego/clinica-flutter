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
}
