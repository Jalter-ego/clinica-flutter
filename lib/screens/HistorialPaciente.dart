import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../componets/CustomAppBar.dart';
import '../componets/CustomButtom.dart';
import '../servicios/consultaServices.dart';
import '../servicios/notificationServices.dart';
import '../servicios/triajeServices.dart';
import '../servicios/tratamientoServices.dart';
import '../servicios/cirugiaServices.dart';
import '../servicios/antecedentesServices.dart';
import '../servicios/diagnosticoServices.dart';
import 'Registers/AntecedentesPaciente.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/widgets.dart' as pw;

class HistorialScreen extends StatefulWidget {
  final int idPaciente;

  const HistorialScreen({super.key, required this.idPaciente});

  @override
  _HistorialScreenState createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  late Future<List<Map<String, dynamic>>> _triajes;
  late Future<List<Map<String, dynamic>>> _tratamientos;
  late Future<List<Map<String, dynamic>>> _cirugias;
  late Future<Map<String, dynamic>> _antecedentes;
  late Future<List<Map<String, dynamic>>> _consultas;
  late Future<List<Map<String, dynamic>>> _diagnosticos;
  

void _reporte() async {
  try {
    // Obtener los datos de las diferentes secciones
    var consultas = await _consultas;
    var diagnosticos = await _diagnosticos;
    var tratamientos = await _tratamientos;
    var cirugias = await _cirugias;
    var triajes = await _triajes;
    var antecedentes = await _antecedentes;

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Reporte de Historial del Paciente',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),

              // Consultas Médicas
              pw.Text('Consultas Médicas:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              ...consultas.map((consulta) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Tipo: ${consulta['tipo_de_consulta']}'),
                    pw.Text('Motivo: ${consulta['motivo_consulta']}'),
                    pw.Text('Diagnóstico: ${consulta['diagnostico_principal']}'),
                    pw.Text('Fecha: ${consulta['fecha']}'),
                    pw.SizedBox(height: 10),
                  ],
                );
              }).toList(),

              // Diagnósticos
              pw.Text('Diagnósticos:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              ...diagnosticos.map((diagnostico) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Tipo: ${diagnostico['tipo_diagnostico']}'),
                    pw.Text('Descripción: ${diagnostico['descripcion']}'),
                    pw.Text('Fecha: ${diagnostico['fecha']}'),
                    pw.SizedBox(height: 10),
                  ],
                );
              }).toList(),

              // Tratamientos
              pw.Text('Tratamientos:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              ...tratamientos.map((tratamiento) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Descripción: ${tratamiento['descripcion']}'),
                    pw.Text('Medicamento: ${tratamiento['medicacion']}'),
                    pw.Text('Fecha: ${tratamiento['fecha_inicio']}'),
                    pw.SizedBox(height: 10),
                  ],
                );
              }).toList(),

              // Cirugías
              pw.Text('Cirugías:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              ...cirugias.map((cirugia) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Tipo: ${cirugia['tipo_cirugia']}'),
                    pw.Text('Estado: ${cirugia['estado']}'),
                    pw.Text('Fecha: ${cirugia['fecha']}'),
                    pw.SizedBox(height: 10),
                  ],
                );
              }).toList(),

              // Triajes
              pw.Text('Triajes:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              ...triajes.map((triaje) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Fecha: ${triaje['fecha']}'),
                    pw.Text('Nivel de prioridad: ${triaje['nivel_prioridad']}'),
                    pw.SizedBox(height: 10),
                  ],
                );
              }).toList(),

              // Antecedentes
              pw.Text('Antecedentes:', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.Text('Nombre del Paciente: ${antecedentes['paciente']['nombre']}'),
              pw.Text('Fecha de Apertura: ${antecedentes['fecha_apertura']}'),
              pw.SizedBox(height: 10),
            ],
          );
        },
      ),
    );

    // Guardar el archivo PDF en el dispositivo
    final directory = await getExternalStorageDirectory();
    final filePath = path.join(directory!.path, 'reporte_historial_paciente.pdf');
    final file = File(filePath);

    await file.writeAsBytes(await pdf.save());

    // Notificar al usuario que el PDF fue generado correctamente
    await mostrarNotificacion(
      titulo: 'Reporte descargado',
      cuerpo: 'El reporte de historial fue descargado exitosamente.',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reporte de Historial descargado Exitosamente: $filePath')),
    );
  } catch (e) {
    // Si ocurre un error, mostrar el mensaje correspondiente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al generar el reporte: $e')),
    );
  }
} @override
  void initState() {
    super.initState();
    _triajes = TriajeServices().getTriajesPorUsuario(widget.idPaciente);
    _tratamientos = TratamientoServices().getTratamientosPorUsuario(widget.idPaciente);
    _cirugias = CirugiaServices().getCirugiasPorPaciente(widget.idPaciente);
    _antecedentes = AntecedentesServices().getAntecedenteById(widget.idPaciente);
    _consultas = ConsultasServices().getConsultasPorUsuario(widget.idPaciente);
    _diagnosticos = DiagnosticoServices().getDiagnosticosPorUsuario(widget.idPaciente);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Mi',
        title2: 'Historial',
        icon: Icons.arrow_circle_left_outlined,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomButton(
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      text: 'Reporte de Historial',
                      onPressed: _reporte),
          _buildSectionTitle("Consultas Médicas", Icons.local_hospital),
          _buildConsultasSection(),
          _buildSectionTitle("Diagnósticos", Icons.assignment),
          _buildDiagnosticosSection(),
          _buildSectionTitle("Tratamientos", Icons.medication_liquid_sharp),
          _buildTratamientosSection(),
          _buildSectionTitle("Cirugías", Icons.cut_sharp),
          _buildCirugiasSection(),
          _buildSectionTitle("Triajes", Icons.access_alarm),
          _buildTriajesSection(),
          _buildSectionTitle("Antecedentes", Icons.history),
          _buildAntecedentesSection(),
        ],
        ),
      ),
    );
  }

 Widget _buildSectionTitle(String title, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // Esto centra los elementos en el Row
      children: [
        Icon(icon, size: 24, color: Colors.blue), // Icono
        SizedBox(width: 10), // Espacio entre el icono y el texto
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}


  // Consultas Section
 Widget _buildConsultasSection() {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: _consultas,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        var consultas = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: consultas.length,
          itemBuilder: (context, index) {
            var consulta = consultas[index];
            return ListTile(
              title: Text(consulta['tipo_de_consulta']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Motivo -> ${consulta['motivo_consulta']}'),
                  Text('Diagnóstico -> ${consulta['diagnostico_principal']}'),
                  Text('Fecha: ${consulta['fecha']}'),
                ],
              ),
            );
          },
        );
      } else {
        return Text('No hay consultas disponibles');
      }
    },
  );
}


  // Diagnósticos Section
  Widget _buildDiagnosticosSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _diagnosticos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var diagnosticos = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: diagnosticos.length,
            itemBuilder: (context, index) {
              var diagnostico = diagnosticos[index];
              return ListTile(
                title: Text('Tipo de Diagnostico -> ${diagnostico['tipo_diagnostico']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${diagnostico['descripcion']}'),
                  Text('Fecha: ${diagnostico['fecha']}'),
                ],
                )
              );
            },
          );
        } else {
          return Text('No hay diagnósticos disponibles');
        }
      },
    );
  }

  // Tratamientos Section
  Widget _buildTratamientosSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _tratamientos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var tratamientos = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tratamientos.length,
            itemBuilder: (context, index) {
              var tratamiento = tratamientos[index];
              return ListTile(
                title: Text(tratamiento['descripcion']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tratamiento['medicacion']),
                  Text('Fecha: ${tratamiento['fecha_inicio']}'),
                ],
                )
              );
            },
          );
        } else {
          return Text('No hay tratamientos disponibles');
        }
      },
    );
  }

  // Cirugías Section
  Widget _buildCirugiasSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _cirugias,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var cirugias = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cirugias.length,
            itemBuilder: (context, index) {
              var cirugia = cirugias[index];
              return ListTile(
                title: Text(cirugia['tipo_cirugia']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cirugia['estado']),
                  Text('Fecha: ${cirugia['fecha']}'),
                ],
                )
              );
            },
          );
        } else {
          return Text('No hay cirugías disponibles');
        }
      },
    );
  }

  // Triajes Section
  Widget _buildTriajesSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _triajes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var triajes = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: triajes.length,
            itemBuilder: (context, index) {
              var triaje = triajes[index];
              return ListTile(
                title: Text('Triaje del: ${triaje['fecha']}'),
                subtitle: Text('Nivel de prioridad: ${triaje['nivel_prioridad']}'),
              );
            },
          );
        } else {
          return Text('No hay triajes disponibles');
        }
      },
    );
  }

  // Antecedentes Section
  Widget _buildAntecedentesSection() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _antecedentes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var antecedentes = snapshot.data!;
          return ListTile(
            title: Text('Antecedentes de: ${antecedentes['paciente']['nombre']}'),
            subtitle: Text('Fecha de apertura: ${antecedentes['fecha_apertura']}'),
            onTap: () {
            // Navegar a la pantalla de detalles del antecedente
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AntecedentesPaciente(
                  id: widget.idPaciente, // Pasar el ID del paciente
                ),
              ),
            );
          },
          );
        } else {
          return Text('No hay antecedentes disponibles');
        }
      },
    );
  }
}
