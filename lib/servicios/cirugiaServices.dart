import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constantes.dart';

class CirugiaServices {
  Future<List<Map<String, dynamic>>> getCirugiasPorPaciente(int pacienteId) async {
    final response = await http.get(Uri.parse('${Constantes.uri}/cirugias/listarByPaciente/$pacienteId'));

    if (response.statusCode == 200) {
      List<dynamic> cirugias = json.decode(response.body);

      return cirugias.map((c) {
        return {
          'id': c['id'],
          'id_paciente': c['id_paciente'],
          'id_especialista': c['id_especialista'],
          'fecha': c['fecha'],
          'hora': c['hora'],
          'tipo_cirugia': c['tipo_cirugia'],
          'estado': c['estado'],
          'observaciones': c['observaciones'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load cirugias');
    }
  }
}
