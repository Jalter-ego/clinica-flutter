import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constantes.dart';

class DepartmentsServices {
  Future<List<Map<String, dynamic>>> fetchDepartments() async {
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
