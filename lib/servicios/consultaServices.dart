import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constantes.dart';

class ConsultasServices {
  Future<List<Map<String, dynamic>>> getConsultasPorUsuario(int usuarioId) async {
    final response = await http.get(Uri.parse('${Constantes.uri}/consultas/usuario/$usuarioId'));

    if (response.statusCode == 200) {
      List<dynamic> consultas = json.decode(response.body);

      return consultas.map((c) {
        return {
          'id': c['id'],
          'refraccion': c['refraccion'],
          'tonometria': c['tonometria'],
          'biomicroscopia': c['biomicroscopia'],
          'fondo_de_ojo': c['fondo_de_ojo'],
          'campo_visual': c['campo_visual'],
          'tipo_de_consulta': c['tipo_de_consulta'],
          'diagnostico_principal': c['diagnostico_principal'],
          'diagnostico_secundario': c['diagnostico_secundario'],
          'fecha': c['fecha'],
          'hora_inicio': c['hora_inicio'],
          'hora_fin': c['hora_fin'],
          'test_lagrimal': c['test_lagrimal'],
          'motivo_consulta': c['motivo_consulta'],
          'id_triaje': c['id_triaje'],
          'id_usuario': c['id_usuario'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load consultas');
    }
  }
}
