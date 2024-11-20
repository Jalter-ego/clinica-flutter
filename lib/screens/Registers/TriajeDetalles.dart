import 'package:flutter/material.dart';

import '../../componets/CustomAppBar.dart';

class TriajeDetailsScreen extends StatelessWidget {
  final int id;
  final int usuarioId;
  final String nivelPrioridad;
  final String fecha;
  final String hora;
  final double frecuenciaCardiaca;
  final double frecuenciaRespiratoria;
  final double temperatura;
  final double saturacionOxigeno;
  final String presionArterial;
  final String descripcion;
  final double visionInicialOd;
  final double visionInicialOi;

  // Constructor para recibir los parámetros
  const TriajeDetailsScreen({
    Key? key,
    required this.id,
    required this.usuarioId,
    required this.nivelPrioridad,
    required this.fecha,
    required this.hora,
    required this.frecuenciaCardiaca,
    required this.frecuenciaRespiratoria,
    required this.temperatura,
    required this.saturacionOxigeno,
    required this.presionArterial,
    required this.descripcion,
    required this.visionInicialOd,
    required this.visionInicialOi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(
        title1: 'Detalles de',
        title2: 'Triajes',
        icon: Icons.arrow_back_ios_rounded,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: $id', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Usuario ID: $usuarioId', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Prioridad: $nivelPrioridad', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Fecha: $fecha', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Hora: $hora', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Frecuencia Cardiaca: $frecuenciaCardiaca', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Frecuencia Respiratoria: $frecuenciaRespiratoria', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Temperatura: $temperatura', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Saturación de Oxígeno: $saturacionOxigeno', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Presión Arterial: $presionArterial', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Descripción: $descripcion', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Visión Inicial OD: $visionInicialOd', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Visión Inicial OI: $visionInicialOi', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
