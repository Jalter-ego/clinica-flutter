import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart'; // Necesario para formatear la fecha
import 'package:shared_preferences/shared_preferences.dart'; // Para guardar en localStorage
import 'cupos.dart'; // Asegúrate de tener este archivo creado
import '../servicios/citasServices.dart';
import '../componets/CustomAppBar.dart';
import '../componets/CustomButtom.dart';

class Horarios extends StatefulWidget {
  const Horarios({super.key});

  @override
  _HorariosState createState() => _HorariosState();
}

class _HorariosState extends State<Horarios> {
  final TextEditingController _diaController = TextEditingController();
  List<Map<String, dynamic>> _horarios = [];
  bool _isLoading = false;
  DateTime? _selectedDate;

  Future<void> cargarHorarios(String diaSeleccionado) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> especialistas = await CitasServices().listarEspecialistasConHorarios();
      List<Map<String, dynamic>> horariosFiltrados = [];

      // Debug: Verificar los especialistas obtenidos
      print('Especialistas obtenidos: $especialistas');

      for (var especialista in especialistas) {
        for (var horario in especialista['horarios']) {
          List<dynamic> fechas = horario['fechas'];

          // Verificamos si el día seleccionado está en las fechas del horario
          if (fechas.contains(diaSeleccionado)) {
            horariosFiltrados.add({
              'nombre': '${especialista['nombre']}',
              'servicio': horario['servicio']['nombre'],
              'hora_inicio': horario['horaInicio'],
              'hora_fin': horario['horaFinal'],
            });
          }
        }
      }

      setState(() {
        _horarios = horariosFiltrados;
      });
    } catch (error) {
      print('Error al cargar horarios: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Guardar datos en SharedPreferences
  Future<void> _guardarDatosEnLocal(Map<String, dynamic> datosFila) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre', datosFila['nombre']);
    await prefs.setString('servicio', datosFila['servicio']);
    await prefs.setString('hora_inicio', datosFila['hora_inicio']);
    await prefs.setString('hora_fin', datosFila['hora_fin']);
    await prefs.setString('fecha', _diaController.text);
  }

  // Función para mostrar el calendario y seleccionar la fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _diaController.text = DateFormat('yyyy-MM-dd').format(picked); // Formateamos la fecha al formato correcto
      });
    }
  }

  void _irACupos(Map<String, dynamic> datosFila) async {
    await _guardarDatosEnLocal(datosFila); // Guardar datos de la fila en SharedPreferences
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Cupos()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Vista de',
        title2: 'Horarios',
        icon: Icons.date_range_outlined,
        onIconPressed: () {
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _diaController,
                    readOnly: true, // Para evitar que el usuario escriba manualmente
                    decoration: InputDecoration(
                      labelText: 'Selecciona un día',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onTap: () {
                      _selectDate(context); // Mostrar el calendario
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 100,
                  child: CustomButton(
                    text: 'Cargar',
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_diaController.text.isNotEmpty) {
                        cargarHorarios(_diaController.text); // Cargar los horarios según la fecha seleccionada
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _horarios.isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text('Especialista', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              DataColumn(
                                label: Text('Servicio', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              DataColumn(
                                label: Text('Hora Inicio', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              DataColumn(
                                label: Text('Hora Fin', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                            rows: _horarios.map((horario) {
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(horario['nombre']), onTap: () {
                                    _irACupos(horario); // Navegar a cupos con los datos de la fila
                                  }),
                                  DataCell(Text(horario['servicio']), onTap: () {
                                    _irACupos(horario); // Navegar a cupos
                                  }),
                                  DataCell(Text(horario['hora_inicio']), onTap: () {
                                    _irACupos(horario); // Navegar a cupos
                                  }),
                                  DataCell(Text(horario['hora_fin']), onTap: () {
                                    _irACupos(horario); // Navegar a cupos
                                  }),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    : const Text('No hay horarios disponibles para este día.'),
          ],
        ),
      ),
    );
  }
}
