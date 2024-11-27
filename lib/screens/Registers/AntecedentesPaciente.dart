import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../componets/CustomAppBar.dart';
import '../../servicios/antecedentesServices.dart';

class AntecedentesPaciente extends StatefulWidget {
  final int id; // Recibimos el id del paciente

  // Constructor para recibir el id como parámetro
  const AntecedentesPaciente({super.key, required this.id});

  @override
  _AntecedentesPacienteState createState() => _AntecedentesPacienteState();
}

class _AntecedentesPacienteState extends State<AntecedentesPaciente> {
  bool isLoading = true;
  Map<String, dynamic> pacienteData = {};

  @override
  void initState() {
    super.initState();
    _fetchAntecedentesPacienteData();
  }

  // Función que obtiene los antecedentes del paciente
  Future<void> _fetchAntecedentesPacienteData() async {
    try {
      final data = await AntecedentesServices().getAntecedenteById(widget.id);
      setState(() {
        pacienteData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching antecedente data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Antecedentes',
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
                  Text(
                    'Paciente: ${pacienteData['paciente']['nombre']} ${pacienteData['paciente']['apellido_paterno']} ${pacienteData['paciente']['apellido_materno']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Email: ${pacienteData['paciente']['email']}',style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 20),
                  Text('Fecha de apertura: ${_formatDate(pacienteData['fecha_apertura'])}',style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 20),
                  const Text(
                    'Antecedentes:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pacienteData['antecedentes']?.length ?? 0,
                      itemBuilder: (context, index) {
                        var ant = pacienteData['antecedentes'][index];
                        return ListTile(
                          title: Text(
                            '${ant['tipo_antecedente']}: ${ant['descripcion']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            'Evento: ${_formatDate(ant['fecha_evento'])}',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          trailing: Icon(
                            ant['es_importante'] ? Icons.warning : Icons.check,
                            color: ant['es_importante'] ? Colors.red : Colors.green,
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
