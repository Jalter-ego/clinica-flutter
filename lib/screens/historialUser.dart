import 'package:OptiVision/componets/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../componets/CustomButtom.dart';
import '../servicios/HistorilServices.dart';
import '../servicios/notificationServices.dart';
import 'Registers/mock_data.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  AntecedentesPageState createState() => AntecedentesPageState();
}

class AntecedentesPageState extends State<HistorialPage> {
  late Future<List<Map<String, dynamic>>> antecedentes;

  void _reporte() async {
    try {
      await HistorialService.report(1);
      await mostrarNotificacion(
        titulo: 'Reporte descargado',
        cuerpo: 'El reporte de historial fue descargado exitosamente.',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte de antecedentes descargado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al generar el reporte')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Mi Historial',
        icon: LineAwesomeIcons.angle_left_solid,
        title2: '',
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          CustomButton(
              textColor: Colors.white,
              backgroundColor: Colors.green,
              text: 'Reporte de antecedentes',
              onPressed: _reporte),
          _buildSection(
            'Antecedentes',
            (antecedentesMock['antecedentes'] as List<dynamic>?) ?? [],
          ),
          _buildSection('Consultas', consultasMock),
          _buildSection('Diagnósticos', diagnosticosMock),
          _buildSection('Tratamientos', tratamientosMock),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 68, 85, 102),
            ),
          ),
        ),
        ...items.map((item) => _buildCard(item)).toList(),
      ],
    );
  }

  Widget _buildCard(Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 68, 85, 102),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            child: Text(
              data['tipo'] ?? 'Tipo no especificado',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Descripción', data['descripcion']),
                const Divider(),
                _buildInfoRow('Fecha del Evento', _formatDate(data['fecha'])),
                const Divider(),
                _buildEstadoChip('Importante', data['es_importante']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            color: Colors.black38,
          ),
        ),
        Expanded(
          child: Text(
            value ?? 'No disponible',
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEstadoChip(String title, bool? estado) {
    Color estadoColor = estado == true ? Colors.green : Colors.grey;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            color: Colors.black38,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: estadoColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            estado == true ? 'Sí' : 'No',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: estadoColor,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String? date) {
    if (date == null) return 'Fecha no disponible';
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return 'Fecha inválida';
    }
  }
}
