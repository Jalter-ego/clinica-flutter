import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../componets/CustomAppBar.dart';
import '../componets/CustomButtom.dart';
import '../servicios/citasServices.dart';

class Cupos extends StatefulWidget {
  const Cupos({Key? key}) : super(key: key);

  @override
  _CuposState createState() => _CuposState();
}

class _CuposState extends State<Cupos> {
  List<Map<String, dynamic>> citas = [];
  bool isLoading = true;

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

  void _showModalRegistroCita(String horaInicio, String horaFin, String fecha) {
    final TextEditingController _idUsuarioController = TextEditingController();
    final TextEditingController _idEspecialistaController = TextEditingController();
    final TextEditingController _idServicioController = TextEditingController();
    final TextEditingController _comentariosController = TextEditingController();

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
                  controller: _idEspecialistaController,
                  decoration: InputDecoration(labelText: 'ID Especialista'),
                ),
                TextField(
                  controller: _idServicioController,
                  decoration: InputDecoration(labelText: 'ID Servicio'),
                ),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(labelText: fecha, hintText: fecha),
                ),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(labelText: horaInicio, hintText: horaInicio),
                ),
                TextField(
                  controller: _comentariosController,
                  decoration: InputDecoration(labelText: 'Comentarios'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Aquí puedes llamar a la función para registrar la cita
                // Puedes acceder a los datos de los controladores
                // y hacer la lógica necesaria para registrar la cita
                Navigator.of(context).pop(); // Cierra el modal
              },
              child: Text('Registrar Cita'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el modal
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
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
                    cita['especialista'] == datos['nombre'],
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
                                // Abre el modal al presionar la celda
                                _showModalRegistroCita(cupo['hora_inicio']!, cupo['hora_fin']!, datos['fecha']!);
                              },
                            ),
                            DataCell(Text(cupo['hora_fin']!)),
                            DataCell(Text(cupo['paciente']!)),
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
