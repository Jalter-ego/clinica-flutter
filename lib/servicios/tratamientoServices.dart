import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constantes.dart';

class TratamientoServices {
  Future<List<Map<String, dynamic>>> getTratamientosPorUsuario(int usuarioId) async {
    final response = await http.get(Uri.parse('${Constantes.uri}/tratamientos/usuario/$usuarioId'));

    if (response.statusCode == 200) {
      List<dynamic> tratamientos = json.decode(response.body);

      return tratamientos.map((t) {
        return {
          'id': t['id'],
          'consulta_id': t['consulta_id'],
          'descripcion': t['descripcion'],
          'tipo_tratamiento': t['tipo_tratamiento'],
          'medicacion': t['medicacion'],
          'duracion_estimada': t['duracion_estimada'],
          'fecha_inicio': t['fecha_inicio'],
          'fecha_fin': t['fecha_fin'],
          'observaciones': t['observaciones'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load tratamientos');
    }
  }
}
