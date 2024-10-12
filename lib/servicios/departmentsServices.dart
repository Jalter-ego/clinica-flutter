import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constantes.dart';

class DepartmentsServices {
  Future<void> createDepartment(String nombre) async {
    final response = await http.post(
      Uri.parse('${Constantes.uri}/departamentos/crear'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'nombre': nombre}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create department');
    }
  }

  Future<void> deleteDepartment(int id) async {
    final response = await http.delete(
      Uri.parse('${Constantes.uri}/departamentos/eliminar'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete department');
    }
  }

  Future<void> editDepartment(int id, String nombre) async {
    final response = await http.put(
      Uri.parse('${Constantes.uri}/departamentos/editar'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'id': id, 'nombre': nombre}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete department');
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
}
