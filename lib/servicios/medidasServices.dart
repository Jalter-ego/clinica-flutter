import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constantes.dart';

class MedidasServices {
   Future<List<Map<String, dynamic>>> listarMedidas() async {
    final response = await http.get(Uri.parse('${Constantes.uri}/medidas-lentes/listar'));

    if (response.statusCode == 200) {
      List<dynamic> medidas = json.decode(response.body);
      return medidas.map((m) {
        return {
          'id': m['id'],
          'id_paciente': m['id_paciente'],
          'esfera_od': m['esfera_od'],
          'cilindro_od': m['cilindro_od'],
          'eje_od': m['eje_od'],
          'adicion_od': m['adicion_od'],
          'esfera_oi': m['esfera_oi'],
          'cilindro_oi': m['cilindro_oi'],
          'eje_oi': m['eje_oi'],
          'adicion_oi': m['adicion_oi'],
          'fecha': m['fecha'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load medidas');
    }
  }
  
  Future<List<Map<String, dynamic>>> getMedidasPorUsuario(int usuarioId) async {
    final response = await http.get(Uri.parse('${Constantes.uri}/medidas-lentes/usuario/$usuarioId'));

    if (response.statusCode == 200) {
      List<dynamic> medidas = json.decode(response.body);
      return medidas.map((m) {
        return {
          'id': m['id'],
          'id_paciente': m['id_paciente'],
          'esfera_od': m['esfera_od'],
          'cilindro_od': m['cilindro_od'],
          'eje_od': m['eje_od'],
          'adicion_od': m['adicion_od'],
          'esfera_oi': m['esfera_oi'],
          'cilindro_oi': m['cilindro_oi'],
          'eje_oi': m['eje_oi'],
          'adicion_oi': m['adicion_oi'],
          'fecha': m['fecha'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load medidas');
    }
  }

  Future<bool> crearMedida({
    required int idPaciente,
    required double esferaOd,
    required double cilindroOd,
    required int ejeOd,
    required double adicionOd,
    required double esferaOi,
    required double cilindroOi,
    required int ejeOi,
    required double adicionOi,
    required String fecha,
  }) async {
    try {
      // Cuerpo de la solicitud en formato JSON
      final Map<String, dynamic> data = {
        'id_paciente': idPaciente,
        'esfera_od': esferaOd,
        'cilindro_od': cilindroOd,
        'eje_od': ejeOd,
        'adicion_od': adicionOd,
        'esfera_oi': esferaOi,
        'cilindro_oi': cilindroOi,
        'eje_oi': ejeOi,
        'adicion_oi': adicionOi,
        'fecha': fecha,
      };

      // Realizar la solicitud POST
      final response = await http.post(
        Uri.parse('${Constantes.uri}/medidas-lentes/crear'), // Asegúrate de configurar la URL correcta
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data), // Codificar los datos en formato JSON
      );

      // Comprobar si la respuesta fue exitosa
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; // Si fue exitosa, retornar true
      } else {
        throw Exception('Failed to create medida');
      }
    } catch (e) {
      print('Error al crear la medida: $e');
      return false; // Si ocurre un error, retornar false
    }
  }
}
