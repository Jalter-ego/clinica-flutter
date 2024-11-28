import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../utils/constantes.dart';
import 'package:http/http.dart' as http;

class HistorialService {
  static Future<List<Map<String, dynamic>>> getAntecedentesByUser(
      int id) async {
    final response =
        await http.get(Uri.parse('${Constantes.uri}/antecedentes/obtener/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> consultasData =
          data['antecedentes']; // Accedemos a la lista de antecedentes
      List<Map<String, dynamic>> antecedentes =
          consultasData.map((e) => Map<String, dynamic>.from(e)).toList();

      return antecedentes;
    } else {
      throw Exception('Failed to load antecedentes');
    }
  }

  static Future<List<Map<String, dynamic>>> getConsultasByUser(int id) async {
    final response =
        await http.get(Uri.parse('${Constantes.uri}/consultas/usuario/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> consultasData = data['consultas'];
      List<Map<String, dynamic>> consultas =
          consultasData.map((e) => Map<String, dynamic>.from(e)).toList();

      return consultas;
    } else {
      throw Exception('Failed to load consultas');
    }
  }

  static Future<List<Map<String, dynamic>>> getDiagnosticosByUser(
      int id) async {
    final response =
        await http.get(Uri.parse('${Constantes.uri}/diagnosticos/usuario/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> diagnosticoData = data['diagnosticos'];
      List<Map<String, dynamic>> diagnosticos =
          diagnosticoData.map((e) => Map<String, dynamic>.from(e)).toList();

      return diagnosticos;
    } else {
      throw Exception('Failed to load diagnosticos');
    }
  }

  static Future<List<Map<String, dynamic>>> getTratamientosByUser(
      int id) async {
    final response =
        await http.get(Uri.parse('${Constantes.uri}/tratamientos/usuario/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> tratamientoData = data['tratamientos'];
      List<Map<String, dynamic>> tratamientos =
          tratamientoData.map((e) => Map<String, dynamic>.from(e)).toList();

      return tratamientos;
    } else {
      throw Exception('Failed to load tratamientos');
    }
  }

  static Future<void> report(int userId) async {
    final url = Uri.parse('${Constantes.uri}/reporte/antecedentes/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final dir = await getExternalStorageDirectory();
      final file = File('${dir!.path}/reporte_antecedentes_$userId.pdf');
      await file.writeAsBytes(bytes); // Guardamos el archivo

      print('Reporte descargado en ${file.path}');
    } else {
      throw Exception('Error al generar el reporte');
    }
  }

  static Future<void> reportHistorial(int userId) async {
    final url = Uri.parse('${Constantes.uri}/reporte/historial-clinico/1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final dir = await getExternalStorageDirectory();
      final file = File('${dir!.path}/reporte_historial_$userId.pdf');
      await file.writeAsBytes(bytes); // Guardamos el archivo

      print('Reporte descargado en ${file.path}');
    } else {
      throw Exception('Error al generar el reporte');
    }
  }
}
