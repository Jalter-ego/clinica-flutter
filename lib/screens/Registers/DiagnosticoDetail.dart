import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../componets/CustomAppBar.dart';
import '../../servicios/diagnosticoServices.dart';

class DiagnosticoDetail extends StatefulWidget {
  final int id; // Recibimos el id de la consulta como parámetro

  const DiagnosticoDetail({Key? key, required this.id}) : super(key: key);

  @override
  _DiagnosticoDetailState createState() => _DiagnosticoDetailState();
}

class _DiagnosticoDetailState extends State<DiagnosticoDetail> {
  Map<String, dynamic>? diagnostico;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDiagnostico();
  }

  // Función para obtener los detalles del diagnóstico por consulta
  Future<void> _fetchDiagnostico() async {
    try {
      final fetchedDiagnostico = await DiagnosticoServices().getDiagnosticosPorConsulta(widget.id);
      if (fetchedDiagnostico.isNotEmpty) {
        setState(() {
          diagnostico = fetchedDiagnostico[0]; // Usamos el primer diagnóstico en la lista
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // Si no se encuentra diagnóstico, mostramos un mensaje
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró diagnóstico para esta consulta')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching diagnostico: $e");
      // Mostramos un error si no se puede obtener el diagnóstico
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar el diagnóstico')),
      );
    }
  }

  // Formateamos la fecha para mostrarla de manera legible
  String _formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Detalles de',
        title2: 'Diagnósticos',
        icon: Icons.arrow_back_ios_rounded,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Mostramos un indicador de carga
          : diagnostico == null
              ? const Center(child: Text('No se encontraron detalles para este diagnóstico.'))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${diagnostico!['id']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Consulta ID: ${diagnostico!['consulta_id']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Descripción: ${diagnostico!['descripcion']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tipo de Diagnóstico: ${diagnostico!['tipo_diagnostico']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Fecha: ${_formatDate(diagnostico!['fecha'])}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Volver a la pantalla anterior
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text('Volver'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
