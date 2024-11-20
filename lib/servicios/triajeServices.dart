import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constantes.dart';

class TriajeServices {
  // Obtener lista de triajes
  Future<List<Map<String, dynamic>>> getTriajes() async {
    final response =
        await http.get(Uri.parse('${Constantes.uri}/triaje/listar'));

    if (response.statusCode == 200) {
      List<dynamic> triajes = json.decode(response.body);
      return triajes.map((t) => {
            'id': t['id'],
            'usuario_id': t['usuario_id'],
            'fecha': t['fecha'],
            'hora': t['hora'],
            'nivel_prioridad': t['nivel_prioridad'],
            'frecuencia_cardiaca': t['frecuencia_cardiaca'],
            'frecuencia_respiratoria': t['frecuencia_respiratoria'],
            'temperatura': t['temperatura'],
            'saturacion_oxigeno': t['saturacion_oxigeno'],
            'presion_arterial': t['presion_arterial'],
            'descripcion': t['descripcion'],
          }).toList();
    } else {
      throw Exception('Failed to load triajes');
    }
  }
  Future<bool> crearTriaje({
    required int usuarioId,
    required String fecha,
    required String hora,
    required String nivelPrioridad,
    required double frecuenciaCardiaca,
    required double frecuenciaRespiratoria,
    required double temperatura,
    required double saturacionOxigeno,
    required String presionArterial,
    required String descripcion,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Constantes.uri}/triaje/crear'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'usuario_id': usuarioId,
          'fecha': fecha,
          'hora': hora,
          'nivel_prioridad': nivelPrioridad,
          'frecuencia_cardiaca': frecuenciaCardiaca,
          'frecuencia_respiratoria': frecuenciaRespiratoria,
          'temperatura': temperatura,
          'saturacion_oxigeno': saturacionOxigeno,
          'presion_arterial': presionArterial,
          'descripcion': descripcion,
        }),
      );

      if (response.statusCode == 200) {
        return true; // El triaje fue creado con éxito
      } else {
        return false; // Hubo un error al crear el triaje
      }
    } catch (e) {
      print('Error al crear el triaje: $e');
      return false; // Si ocurre un error, devolvemos false
    }
  }
    Future<bool> eliminarTriaje(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${Constantes.uri}/triaje/eliminar'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id': id,
        }),
      );

      print('Respuesta: ${response.body}'); // Verificar el cuerpo de la respuesta

     if (response.statusCode == 200) {
        return true; // El triaje fue eliminado con éxito
       
    } else {
      return false; // Si la respuesta no es 200, consideramos que hubo un error
    }
  } catch (e) {
    print('Error al eliminar el triaje: $e');
    return false; // Si ocurre un error, devolvemos false
  }
  }
}