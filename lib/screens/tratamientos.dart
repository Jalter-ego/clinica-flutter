import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../componets/CustomAppBar.dart';

class TratamientosPage extends StatelessWidget {
  const TratamientosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos locales simulados
    final tratamientos = [
      {
        'descripcion': 'Tratamiento 1',
        'fecha_inicio': [2024, 11, 1],
        'fecha_fin': [2024, 11, 15],
        'estado': 'Pendiente',
      },
      {
        'descripcion': 'Tratamiento 2',
        'fecha_inicio': [2024, 10, 15],
        'fecha_fin': [2024, 10, 30],
        'estado': 'Finalizado',
      },
      {
        'descripcion': 'Tratamiento 3',
        'fecha_inicio': [2024, 9, 1],
        'fecha_fin': [2024, 9, 15],
        'estado': 'Cancelado',
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Mis Tratamientos',
        title2: '',
        icon: Icons.arrow_back_ios_rounded,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: tratamientos
                    .map((tratamiento) =>
                        buildTratamientoCard(context, tratamiento))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTratamientoCard(
      BuildContext context, Map<String, dynamic> tratamiento) {
    String formatFecha(List<dynamic>? fecha) {
      if (fecha != null && fecha.length == 3) {
        final date = DateTime(fecha[0], fecha[1], fecha[2]);
        return DateFormat('dd/MM/yyyy').format(date);
      }
      return 'Desconocido';
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          if (!isDarkMode)
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.grey[800]
                  : const Color.fromARGB(255, 68, 85, 102),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    tratamiento['descripcion'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(LineAwesomeIcons.angle_right_solid),
                  color: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Detalle del tratamiento: ${tratamiento['descripcion']}'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInfoRow(
                  'Fecha de Inicio',
                  formatFecha(tratamiento['fecha_inicio']),
                  isDarkMode,
                ),
                const Divider(),
                buildInfoRow(
                  'Fecha Fin',
                  formatFecha(tratamiento['fecha_fin']),
                  isDarkMode,
                ),
                const Divider(),
                buildEstadoChip('Estado', tratamiento['estado'], isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String title, String? value, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            color: isDarkMode ? Colors.white70 : Colors.black38,
          ),
        ),
        Expanded(
          child: Text(
            value ?? '',
            style: TextStyle(
              fontSize: 12.0,
              color: isDarkMode ? Colors.white54 : Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEstadoChip(String title, String? estado, bool isDarkMode) {
    Color estadoColor = Colors.grey;
    switch (estado) {
      case 'Finalizado':
        estadoColor = Colors.green;
        break;
      case 'Pendiente':
        estadoColor = Colors.orange;
        break;
      case 'Cancelado':
        estadoColor = Colors.red;
        break;
      default:
        estadoColor = Colors.grey;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            color: isDarkMode ? Colors.white70 : Colors.black38,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: estadoColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            estado ?? 'Desconocido',
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
}
