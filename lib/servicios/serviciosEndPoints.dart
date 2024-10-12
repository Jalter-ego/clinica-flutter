import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constantes.dart';

class ServicesEndPoints {
  Future<void> createService(String nombre, String descripcion,
      int idDepartamento, int idEspecialidad) async {
    final response = await http.post(
      Uri.parse('${Constantes.uri}/servicios/crear'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'nombre': nombre,
        'descripcion': descripcion,
        'id_departamento': idDepartamento,
        'id_especialidad': idEspecialidad
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create service');
    }
  }

  Future<void> deleteService(int id) async {
    final response = await http.delete(
      Uri.parse('${Constantes.uri}/servicios/eliminar'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete service');
    }
  }

  Future<void> editService(int id, String nombre, String descripcion) async {
    final response = await http.put(
      Uri.parse('${Constantes.uri}/servicios/editar'),
      headers: {"Content-Type": "application/json"},
      body:
          jsonEncode({'id': id, 'nombre': nombre, 'descripcion': descripcion}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete service');
    }
  }

  Future<List<Map<String, dynamic>>> getServices() async {
    final response =
        await http.get(Uri.parse('${Constantes.uri}/servicios/listar'));

    if (response.statusCode == 200) {
      List<dynamic> servicios = json.decode(response.body);
      return servicios
          .map((s) => {
                'id': s['id'],
                'nombre': s['nombre'],
                'descripcion': s['descripcion']
              })
          .toList();
    } else {
      throw Exception('Failed to load service');
    }
  }

  Future<List<Map<String, dynamic>>> getDepartments() async {
    final response =
        await http.get(Uri.parse('${Constantes.uri}/departamentos/listar'));

    if (response.statusCode == 200) {
      List<dynamic> departments = json.decode(response.body);
      return departments
          .map((d) => {'id': d['id'], 'nombre': d['nombre']})
          .toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }

  Future<List<Map<String, dynamic>>> getSpecialties() async {
    final response =
        await http.get(Uri.parse('${Constantes.uri}/especialidades/listar'));

    if (response.statusCode == 200) {
      List<dynamic> departments = json.decode(response.body);
      return departments
          .map((d) => {'id': d['id'], 'nombre': d['nombre']})
          .toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }
}
