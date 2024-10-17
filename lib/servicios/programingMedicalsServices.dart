import '../utils/constantes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProgramingMedicalsServices {
  Future<void> createProgramacion({
    required String horaInicio,
    required String horaFin,
    required int empleadoId,
    required int especialidadId,
    required int servicioId,
    required List<String> fechas,
  }) async {
    final response = await http.post(
      Uri.parse('${Constantes.uri}/programaciones_medical/crear'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'hora_inicio': horaInicio,
        'hora_fin': horaFin,
        'empleado_id': empleadoId,
        'especialidad_id': especialidadId,
        'servicio_id': servicioId,
        'fechas': fechas,
      }),
    );

    if (response.statusCode == 200) {
      print('Programación creada: ${response.body}');
    } else {
      print('Error al crear la programación: ${response.body}');
      throw Exception('Error al crear la programación');
    }
  }

  static Future<List<Map<String, dynamic>>> getSpecialists() async {
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
          'especialidades': specialist['especialidades'] != null
              ? (specialist['especialidades'] as List<dynamic>)
                  .map((especialidad) {
                  return {
                    'id': especialidad['id'],
                    'nombre': especialidad['nombre'],
                    'tiempo_estimado': especialidad['tiempo_estimado']
                  };
                }).toList()
              : [],
        };
      }).toList();
    } else {
      throw Exception('Failed to load specialists');
    }
  }

  static Future<int?> getSpecialistIdByName(String specialistName) async {
    try {
      List<Map<String, dynamic>> specialists = await getSpecialists();

      final specialist = specialists.firstWhere(
        (s) => '${s['nombre']}'.toLowerCase() == specialistName.toLowerCase(),
        orElse: () => {}, // Devuelve null si no se encuentra
      );
      return specialist?['id']; // Devuelve el ID o null si no se encontró
    } catch (e) {
      print('Error: $e'); // Manejo de errores
      return null; // Retorna null en caso de error
    }
  }

  static Future<List<Map<String, dynamic>>> getServices() async {
    final response =
        await http.get(Uri.parse('${Constantes.uri}/servicios/listar'));

    if (response.statusCode == 200) {
      List<dynamic> servicios = json.decode(response.body);
      return servicios
          .map((s) => {'id': s['id'], 'nombre': s['nombre']})
          .toList();
    } else {
      throw Exception('Failed to load service');
    }
  }

  static Future<int?> getServiceIdByName(String serviceName) async {
    try {
      List<Map<String, dynamic>> services = await getServices();

      final service = services.firstWhere(
        (s) => s['nombre'].toLowerCase() == serviceName.toLowerCase(),
        orElse: () => {}, // Devuelve null si no se encuentra
      );

      return service?['id']; // Devuelve el ID o null si no se encontró
    } catch (e) {
      print('Error: $e'); // Manejo de errores
      return null; // Retorna null en caso de error
    }
  }
}
