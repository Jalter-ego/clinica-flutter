import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constantes.dart'; // Asegúrate de que esta constante esté correctamente definida

class PatologiasServices {

  // Función para obtener la lista de patologías
  Future<List<Map<String, dynamic>>> getPatologias() async {
    // Hacemos la solicitud GET al endpoint de listar patologías
    final response = await http.get(Uri.parse('${Constantes.uri}/patologias/listar'));
    // Verificamos si la respuesta es exitosa (código de estado 200)
    if (response.statusCode == 200) {
      List<dynamic> patologias = json.decode(response.body);
      // Mapeamos la lista de patologías y devolvemos solo los datos que necesitamos
      return patologias.map((p) {
        return {
          'id': p['id'],
          'nombre': p['nombre'],
          'imagen': p['imagen'],
          'descripcion': p['descripcion'],
        };
      }).toList();
    } else {
      // Si la respuesta no es exitosa, lanzamos una excepción
      throw Exception('Failed to load patologías');
    }
  }
  
}