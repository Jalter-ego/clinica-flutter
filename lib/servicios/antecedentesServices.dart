import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constantes.dart';

class AntecedentesServices {
  // Obtener lista de antecedentes
  Future<List<Map<String, dynamic>>> getAntecedentes() async {
    final response =
        await http.get(Uri.parse('${Constantes.uri}/antecedentes/listar'));

    if (response.statusCode == 200) {
      List<dynamic> antecedentes = json.decode(response.body);
      return antecedentes.map((a) {
        return {
          'usuario': {
            'id': a['usuario']['id'],
            'nombre': a['usuario']['nombre'],
            'apellido_paterno': a['usuario']['apellido_paterno'],
            'apellido_materno': a['usuario']['apellido_materno'],
          },
          'fecha_apertura': a['fecha_apertura'],
          'antecedentes': a['antecedentes'].map((ant) {
            return {
              'id': ant['id'],
              'tipo': ant['tipo'],
              'descripcion': ant['descripcion'],
              'especifico1': ant['especifico1'],
              'especifico2': ant['especifico2'],
              'fecha_evento': ant['fecha_evento'],
              'fecha_creacion': ant['fecha_creacion'],
              'es_importante': ant['es_importante'],
            };
          }).toList(),
        };
      }).toList();
    } else {
      throw Exception('Failed to load antecedentes');
    }
  }
  
   Future<Map<String, dynamic>> getAntecedenteById(int id) async {
    final response = await http.get(Uri.parse('${Constantes.uri}/antecedentes/obtener/$id'));

    if (response.statusCode == 200) {
      // Decodificando la respuesta JSON
      var data = json.decode(response.body);

      return {
        'paciente': {
          'id': data['paciente']['id'],
          'nombre': data['paciente']['nombre'],
          'apellido_paterno': data['paciente']['apellido_paterno'],
          'apellido_materno': data['paciente']['apellido_materno'],
          'email': data['paciente']['email'],
        },
        'fecha_apertura': data['fecha_apertura'],
        'antecedentes': data['antecedentes'].map((ant) {
          return {
            'antecedente_id': ant['antecedente_id'],
            'tipo_antecedente': ant['tipo_antecedente'],
            'descripcion': ant['descripcion'],
            'especifico1': ant['especifico1'],
            'especifico2': ant['especifico2'],
            'fecha_evento': ant['fecha_evento'],
            'fecha_creacion': ant['fecha_creacion'],
            'es_importante': ant['es_importante'],
          };
        }).toList(),
      };
    } else {
      throw Exception('Failed to load antecedente by id');
    }
  }
}
