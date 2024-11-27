import 'package:OptiVision/componets/CustomButtom.dart';
import 'package:OptiVision/servicios/HistorilServices.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../componets/CustomAppBar.dart';
import '../../providers/proveedor_usuario.dart';
import '../../servicios/notificationServices.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  AntecedentesPageState createState() => AntecedentesPageState();
}

class AntecedentesPageState extends State<HistorialPage> {
  late Future<List<Map<String, dynamic>>> antecedentes;

  @override
  void initState() {
    super.initState();
    antecedentes = _loadAntecedentes();
  }

  Future<List<Map<String, dynamic>>> _loadAntecedentes() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.ci;

    if (userId != null) {
      try {
        return await HistorialService.getAntecedentesByUser(1);
      } catch (e) {
        debugPrint('Error al cargar atenciones: $e');
        return [];
      }
    } else {
      debugPrint('El usuario no está autenticado.');
      return [];
    }
  }

  void _reporte() async {
    try {
      await HistorialService.report(1);
      await mostrarNotificacion(
        titulo: 'Reporte descargado',
        cuerpo: 'El reporte de historial fue descargado exitosamente.',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Reporte de antecedentes descargado')),
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
        title1: 'Mis antecedentes',
        icon: LineAwesomeIcons.angle_left_solid,
        title2: '',
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: antecedentes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No hay antecedentes disponibles.'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Botón para el reporte encima de los antecedentes
                  CustomButton(
                      textColor: Colors.white,
                      backgroundColor: Colors.green,
                      text: 'Reporte de antecedentes',
                      onPressed: _reporte),
                  // Los antecedentes se muestran después del botón
                  ...snapshot.data!
                      .map((antecedente) => buildAntecedenteCard(antecedente))
                      ,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAntecedenteCard(Map<String, dynamic> antecedente) {
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
              antecedente['tipo_antecedente'] ?? 'Tipo desconocido',
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
                buildInfoRow('Descripción', antecedente['descripcion']),
                const Divider(),
                buildInfoRow('Fecha del Evento',
                    formatDate(antecedente['fecha_evento'])),
                const Divider(),
                buildInfoRow('Especifico 1', antecedente['especifico1']),
                const Divider(),
                buildInfoRow('Especifico 2', antecedente['especifico2']),
                const Divider(),
                buildInfoRow('Fecha de Creación',
                    formatDate(antecedente['fecha_creacion'])),
                const Divider(),
                buildEstadoChip('Importante', antecedente['es_importante']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String title, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
              color: Colors.black38),
        ),
        Expanded(
          child: Text(
            value ?? '',
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEstadoChip(String title, bool? estado) {
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

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
  }
}
