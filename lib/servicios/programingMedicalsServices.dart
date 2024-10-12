import '../utils/constantes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProgramingMedicalsServices {
  Future<List<Map<String, dynamic>>> getSpecialists() async {
    final response =
        await http.get(Uri.parse('${Constantes.uri}/especialistas/listar'));

    if (response.statusCode == 200) {
      List<dynamic> specialists = json.decode(response.body);
      return specialists.map((specialist) {
        return {
          'id': specialist['id'],
          'nombre': specialist['usuario']['nombre'],
          'apellido_paterno': specialist['usuario']['apellido_paterno'],
          'apellido_materno': specialist['usuario']['apellido_materno'],
          'especialidades': specialist['especialidades'].map((especialidad) {
            return {
              'id': especialidad['id'],
              'nombre': especialidad['nombre'],
              'tiempo_estimado': especialidad['tiempo_estimado']
            };
          }).toList(),
        };
      }).toList();
    } else {
      throw Exception('Failed to load specialists');
    }
  }
}
