import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constantes.dart';

class SpecialtiesServices {
  Future<void> createSpecialty(String nombre, int tiempoEstimado) async {
    final response = await http.post(
      Uri.parse('${Constantes.uri}/especialidades/crear'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'nombre': nombre, 'tiempo_estimado': tiempoEstimado}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create specialty');
    }
  }

  Future<void> deleteSpecialty(int id) async {
    final response = await http.delete(
      Uri.parse('${Constantes.uri}/especialidades/eliminar'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete specialty');
    }
  }

  Future<void> editSpecialty(int id, String nombre, int tiempoEstimado) async {
    final response = await http.put(
      Uri.parse('${Constantes.uri}/especialidades/editar'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {'id': id, 'nombre': nombre, 'tiempo_estimado': tiempoEstimado}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete specialty');
    }
  }

  Future<List<Map<String, dynamic>>> getSpecialties() async {
    final response =
        await http.get(Uri.parse('${Constantes.uri}/especialidades/listar'));

    if (response.statusCode == 200) {
      List<dynamic> specialties = json.decode(response.body);
      return specialties
          .map((d) => {
                'id': d['id'],
                'nombre': d['nombre'],
                'tiempo_estimado': d['tiempo_estimado']
              })
          .toList();
    } else {
      throw Exception('Failed to load specialties');
    }
  }
}
