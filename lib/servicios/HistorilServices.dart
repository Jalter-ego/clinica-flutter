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
      // Decodificamos la respuesta y accedemos al campo 'antecedentes'
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> antecedentesData =
          data['antecedentes']; // Accedemos a la lista de antecedentes
      List<Map<String, dynamic>> antecedentes =
          antecedentesData.map((e) => Map<String, dynamic>.from(e)).toList();

      return antecedentes;
    } else {
      throw Exception('Failed to load antecedentes');
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
}
