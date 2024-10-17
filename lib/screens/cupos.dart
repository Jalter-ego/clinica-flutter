import 'dart:ffi';

import 'package:OptiVision/screens/home.dart';
import 'package:OptiVision/servicios/programingMedicalsServices.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../componets/CustomAppBar.dart';
import '../servicios/citasServices.dart';
import '../../servicios/paymentServices.dart';

class Cupos extends StatefulWidget {
  const Cupos({Key? key}) : super(key: key);

  @override
  _CuposState createState() => _CuposState();
}

class _CuposState extends State<Cupos> {
  List<Map<String, dynamic>> citas = [];
  bool isLoading = true;

  final PaymentServices _paymentServices =
      PaymentServices(); 


  Future<Map<String, String?>> _obtenerDatos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'nombre': prefs.getString('nombre'),
      'servicio': prefs.getString('servicio'),
      'hora_inicio': prefs.getString('hora_inicio'),
      'hora_fin': prefs.getString('hora_fin'),
      'fecha': prefs.getString('fecha'),
    };
  }


   Future<void> _handlePaymentAndCita(int usuario, int especialista,int servicio, String fechap, String horap,String comentariop) async {
    try {
      // 1. Crear el PaymentIntent en tu backend
      String clientSecret =
          await _paymentServices.createPaymentIntent(5000, 'usd');
      // 2. Presentar la hoja de pago
      await _paymentServices.presentPaymentSheet(clientSecret);
      // 3. Si el pago es exitoso, proceder con la creación de la cita
      bool success = await CitasServices().crearCita(
        context: context,
        usuarioId: usuario,
        especialistaId: especialista,
        servicioId: servicio,
        fecha: fechap,
        hora: horap,
        comentario: comentariop,
      );
      if (success) {
        // Redirigir a la pantalla de citas y mostrar un mensaje de éxito
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const Cupos()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cita registrada exitosamente.")),
        );
      } else {
        // Mostrar mensaje de error si la cita no se pudo registrar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("No se pudo registrar la cita. Inténtalo de nuevo.")),
        );
      }
    } catch (e) {
      // Manejar errores en el pago o la creación de la cita
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en el proceso: $e")),
      );
    }
  }

  List<Map<String, String>> generarCupos(DateTime horaInicio, DateTime horaFin, int tiempoEstimado) {
    List<Map<String, String>> cupos = [];
    DateTime actual = horaInicio;
    while (actual.isBefore(horaFin)) {
      DateTime fin = actual.add(Duration(minutes: tiempoEstimado));
      if (fin.isAfter(horaFin)) break;
      cupos.add({
        'hora_inicio': '${actual.hour.toString().padLeft(2, '0')}:${actual.minute.toString().padLeft(2, '0')}',
        'hora_fin': '${fin.hour.toString().padLeft(2, '0')}:${fin.minute.toString().padLeft(2, '0')}',
        'paciente': '',
        'estado': ''
      });
      actual = fin;
    }
    return cupos;
  }

  Future<void> _fetchCitas() async {
    try {
      List<Map<String, dynamic>>? citasFromApi =
          await CitasServices().listarCitas(context: context);

      if (citasFromApi != null) {
        setState(() {
          citas = citasFromApi;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showModalRegistroCita(String horaInicio, String horaFin, String fecha) async {
    final TextEditingController _idUsuarioController = TextEditingController();
    final TextEditingController _idEspecialistaController = TextEditingController();
    final TextEditingController _idServicioController = TextEditingController();
    final TextEditingController _comentariosController = TextEditingController();
     final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? nombreServicio = prefs.getString('servicio');
      String? nombreEspecialista= prefs.getString('nombre');
  // Obtener el ID del servicio usando la función de ProgramingMedicalsServices
     int? idServicio = await ProgramingMedicalsServices.getServiceIdByName(nombreServicio ?? '');
     int? idEspecialista = await ProgramingMedicalsServices.getSpecialistIdByName(nombreEspecialista ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Registrar Cita'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _idUsuarioController,
                  decoration: InputDecoration(labelText: 'ID Usuario'),
                ),
                TextField(
                  enabled:false,
                  decoration: InputDecoration(labelText: idEspecialista.toString()),
                ),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(labelText: idServicio.toString()),
                ),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(labelText: fecha),
                ),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(labelText: horaInicio),
                ),
                TextField(
                  controller: _comentariosController,
                  decoration: InputDecoration(labelText: 'Comentarios'),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green, // Color de fondo verde
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
              ),
              child: TextButton(
                onPressed: () {
                  _handlePaymentAndCita(
                    _idUsuarioController.text.isNotEmpty ? int.parse(_idUsuarioController.text) : 0, // ID Usuario
                    idEspecialista ?? 0, // ID Especialista
                    idServicio ?? 0, // ID Servicio
                    fecha, // fecha
                    horaInicio, // horaInicio
                    _comentariosController.text, // comentario
                  );
                },
                child: const Text('Registrar Cita', style: TextStyle(color: Colors.white)), // Texto en blanco
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red, // Color de fondo rojo
                borderRadius: BorderRadius.circular(8), // Bordes redondeados
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el modal
                },
                child: const Text('Cancelar', style: TextStyle(color: Colors.white)), // Texto en blanco
              ),
            ),
          ],

        );
      },
    );
  }
  String cortarHastaPrimerEspacio(String input) {
  int index = input.indexOf(' '); // Encuentra el índice del primer espacio
  if (index == -1) {
    return input; // Si no hay espacios, devuelve el string completo
  }
  return input.substring(0, index); // Devuelve la parte antes del primer espacio
}
  @override
  void initState() {
    super.initState();
    _fetchCitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Detalles de',
        title2: 'Cupos',
        icon: Icons.arrow_back_ios_rounded,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _obtenerDatos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos.'));
          } else if (snapshot.hasData) {
            final datos = snapshot.data!;
            DateTime horaInicio = DateTime.parse('${datos['fecha']} ${datos['hora_inicio']}');
            DateTime horaFin = DateTime.parse('${datos['fecha']} ${datos['hora_fin']}');
            int tiempoEstimado = 20;
            
            List<Map<String, String>> cupos = generarCupos(horaInicio, horaFin, tiempoEstimado);
            for (var cupo in cupos) {
              var citaCoincidente = citas.firstWhere(
                (cita) =>
                    cita['fecha'].split('T')[0] == datos['fecha']  &&
                    cita['hora'].substring(0, 5) == cupo['hora_inicio'] &&
                    cortarHastaPrimerEspacio(cita['especialista']) == datos['nombre'],
                orElse: () => {},
              );

              if (citaCoincidente.isNotEmpty) {
                cupo['paciente'] = citaCoincidente['paciente'] ?? '';
                cupo['estado'] = 'Reservado';
              } else {
                cupo['estado'] = 'Libre';
              }
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre: ${datos['nombre'] ?? ''}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Servicio: ${datos['servicio'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Hora Inicio: ${datos['hora_inicio'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Hora Fin: ${datos['hora_fin'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Fecha: ${datos['fecha'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Hora Inicio')),
                          DataColumn(label: Text('Hora Fin')),
                          DataColumn(label: Text('Paciente')),
                          DataColumn(label: Text('Estado')),
                        ],
                        rows: cupos.map((cupo) {
                          Color estadoColor = (cupo['estado'] == 'Libre') ? Colors.green : Colors.red;

                          return DataRow(cells: [
                            DataCell(
                              Text(cupo['hora_inicio']!),
                              onTap: () {
                                _showModalRegistroCita(cupo['hora_inicio']!, cupo['hora_fin']!, datos['fecha']!);
                              },
                            ),
                            DataCell(Text(cupo['hora_fin']!),
                              onTap: () {
                                _showModalRegistroCita(cupo['hora_inicio']!, cupo['hora_fin']!, datos['fecha']!);
                              },
                            ),
                            DataCell(Text(cupo['paciente']!),
                              onTap: () {
                                _showModalRegistroCita(cupo['hora_inicio']!, cupo['hora_fin']!, datos['fecha']!);
                              },
                            ),
                            DataCell(
                              Text(
                                cupo['estado']!,
                                style: TextStyle(color: estadoColor),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No se encontraron datos.'));
          }
        },
      ),
    );
  }
}
