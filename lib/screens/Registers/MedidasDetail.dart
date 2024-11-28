import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../componets/CustomAppBar.dart';
import '../../servicios/medidasServices.dart'; // Importar el servicio de medidas

class MedidasDetail extends StatefulWidget {
  final int id; // Recibimos el id del paciente

  // Constructor para recibir el id como parámetro
  const MedidasDetail({super.key, required this.id});

  @override
  _MedidasDetailState createState() => _MedidasDetailState();
}

class _MedidasDetailState extends State<MedidasDetail> {
  bool isLoading = true;
  List<Map<String, dynamic>> medidasData = [];

  @override
  void initState() {
    super.initState();
    _fetchMedidasPacienteData();
  }

  // Función que obtiene las medidas del paciente
  Future<void> _fetchMedidasPacienteData() async {
    try {
      final data = await MedidasServices().getMedidasPorUsuario(widget.id);
      setState(() {
        medidasData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching medidas data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Medidas',
        title2: 'Del Paciente',
        icon: Icons.arrow_back_ios_rounded,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalles de las Medidas de Lentes:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: medidasData.length,
                      itemBuilder: (context, index) {
                        var medida = medidasData[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ID Medida: ${medida['id']}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'ID Paciente: ${medida['id_paciente']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Esfera OD: ${medida['esfera_od']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Cilindro OD: ${medida['cilindro_od']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Eje OD: ${medida['eje_od']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Adición OD: ${medida['adicion_od']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Esfera OI: ${medida['esfera_oi']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Cilindro OI: ${medida['cilindro_oi']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Eje OI: ${medida['eje_oi']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Adición OI: ${medida['adicion_oi']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Fecha: ${_formatDate(medida['fecha'])}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Formatear las fechas en formato legible
  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}
