import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../componets/CustomAppBar.dart';  // Importar el AppBar personalizado
import '../componets/CustomButtom.dart';  // Importar el botón personalizado
import '../servicios/citasServices.dart';  // Importar tu servicio para obtener las citas

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
        'paciente': '',  // Se inicializa vacío
        'estado': ''  // El estado lo determinamos más adelante
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
          citas = citasFromApi; // Guardamos las citas obtenidas
          isLoading = false; // Dejamos de cargar
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Si hay error, dejamos de cargar
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCitas(); // Obtenemos las citas al iniciar la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Detalles de',
        title2: 'Cupos',
        icon: Icons.arrow_back_ios_rounded,  // Puedes personalizar este ícono
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
            // Convertir las horas de los datos en DateTime
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
                    // Envuelve la tabla en un scroll horizontal para evitar overflow
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
                            DataCell(Text(cupo['hora_inicio']!)),
                            DataCell(Text(cupo['hora_fin']!)),
                            DataCell(Text(cupo['paciente']!)),
                            DataCell(
                              Text(
                                cupo['estado']!,
                                style: TextStyle(color: estadoColor),  // Aplica el color dinámico
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
