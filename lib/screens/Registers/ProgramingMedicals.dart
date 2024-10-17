import 'package:OptiVision/servicios/programingMedicalsServices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';
import '../../providers/theme_Provider.dart';

class ProgramingMedicals extends StatefulWidget {
  const ProgramingMedicals({super.key});

  @override
  _ProgramingMedicals createState() => _ProgramingMedicals();
}

class _ProgramingMedicals extends State<ProgramingMedicals> {
  List<Map<String, dynamic>> specialists = []; //arreglo de especialistas
  List<Map<String, dynamic>> services = []; //arreglo de servicios
  bool isLoading = true;
  int? selectedSpecialistId; //id de especialista seleccionado
  int? selectedServiceId; //id de servicio seleccionado
  int? selectedSpecialtyId; //id de especialidad seleccionado
  Set<DateTime> selectedDates = {}; //arreglo de dias
  TimeOfDay? selectedStartTime; //hora de inicio
  TimeOfDay? selectedEndTime; //hora de finalizacion

  @override
  void initState() {
    super.initState();
    _fetchPrograming();
  }

  Future<void> _fetchPrograming() async {
    try {
      final fetchedSpecialists =
          await ProgramingMedicalsServices.getSpecialists();
      final fetchedServices = await ProgramingMedicalsServices.getServices();
      setState(() {
        specialists = fetchedSpecialists;
        services = fetchedServices;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching departments: $e");
    }
  }

  void _createProgramacion() async {
    if (selectedSpecialistId == null ||
        selectedServiceId == null ||
        selectedSpecialtyId == null ||
        selectedStartTime == null ||
        selectedEndTime == null ||
        selectedDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    String horaInicio = selectedStartTime!.format(context);
    String horaFin = selectedEndTime!.format(context);

    List<String> fechas =
        selectedDates.map((date) => "${date.toLocal()}".split(' ')[0]).toList();
    print(fechas);
    try {
      await ProgramingMedicalsServices().createProgramacion(
        horaInicio: horaInicio,
        horaFin: horaFin,
        empleadoId: selectedSpecialistId!,
        especialidadId: selectedSpecialtyId!,
        servicioId: selectedServiceId!,
        fechas: fechas,
      );

      selectedServiceId = null;
      selectedSpecialtyId = null;
      selectedStartTime = null;
      selectedEndTime = null;
      selectedDates.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Programación creada exitosamente')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear la programación')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Programacion de',
        title2: 'Medicos',
        icon: Icons.arrow_back_ios_rounded,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(31, 184, 169, 169),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 220,
                        height: 40,
                        child: CustomButton(
                          textColor: Colors.white,
                          backgroundColor: Colors.green,
                          icon: Icons.add,
                          text: 'Agregar Programacion',
                          fontSize: 14,
                          onPressed: () {
                            _showCreateModal();
                            print("Especialista ID: $selectedSpecialistId");
                            print("Fechas seleccionadas: $selectedDates");
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DataTable(
                          columnSpacing: 10.0,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: SizedBox(
                                width: 30,
                                child: Text(
                                  'ID',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Apellidos y Nombres',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          rows: specialists.map((specialist) {
                            bool isSelected =
                                selectedSpecialistId == specialist['id'];

                            return DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  SizedBox(
                                    width: 15,
                                    child: Text(
                                      specialist['id'].toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedSpecialistId = isSelected
                                            ? null
                                            : specialist['id'];
                                      });
                                    },
                                    child: Container(
                                      color: isSelected
                                          ? Colors.green[200]
                                          : Colors.transparent,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        (specialist['apellido_paterno'] +
                                            ' ' +
                                            specialist['apellido_materno'] +
                                            ' ' +
                                            specialist['nombre']),
                                        style: const TextStyle(fontSize: 12),
                                        overflow: TextOverflow.clip,
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TableCalendar(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: DateTime.now(),
                          locale: 'es_ES',
                          selectedDayPredicate: (day) {
                            return selectedDates.contains(day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              if (selectedDates.contains(selectedDay)) {
                                selectedDates.remove(selectedDay);
                              } else {
                                selectedDates.add(selectedDay);
                              }
                            });
                          },
                          calendarStyle: const CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showCreateModal() {
    if (selectedSpecialistId == null) {
      _showAlert('Especialista no seleccionado',
          'Por favor, selecciona un especialista antes de continuar.');
      return;
    }
    if (selectedDates.isEmpty) {
      _showAlert('Dias no seleccionados',
          'Por favor, selecciona al menos un dia antes de continuar.');
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<Map<String, dynamic>> filteredSpecialties = specialists.firstWhere(
          (specialist) => specialist['id'] == selectedSpecialistId,
          orElse: () => {'especialidades': []},
        )['especialidades'];

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Nueva Programacion',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Seleccionar Especialidad',
                            style: TextStyle(fontSize: 14),
                          ),
                          DropdownButton<int>(
                            value: selectedSpecialtyId,
                            items: filteredSpecialties.map((specialty) {
                              return DropdownMenuItem<int>(
                                value: specialty['id'],
                                child: Text(specialty['nombre']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedSpecialtyId = value;
                              });
                            },
                            hint: const Text('Selecciona una especialidad'),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Seleccionar Servicio',
                            style: TextStyle(fontSize: 14),
                          ),
                          DropdownButton<int>(
                            value: selectedServiceId,
                            items: services.map((service) {
                              return DropdownMenuItem<int>(
                                value: service['id'],
                                child: Text(service['nombre']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedServiceId = value;
                              });
                            },
                            hint: const Text('Selecciona un servicio'),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Desde',
                            style: TextStyle(fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () =>
                                _selectTime(context, true, setModalState),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                selectedStartTime != null
                                    ? selectedStartTime!.format(context)
                                    : 'Selecciona una hora',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Hasta',
                            style: TextStyle(fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () =>
                                _selectTime(context, false, setModalState),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                selectedEndTime != null
                                    ? selectedEndTime!.format(context)
                                    : 'Selecciona una hora',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: CustomButton(
                              textColor: Colors.white,
                              backgroundColor: Colors.red,
                              icon: Icons.cancel,
                              text: 'Cancelar',
                              fontSize: 12,
                              onPressed: () {
                                selectedServiceId = null;
                                selectedSpecialtyId = null;
                                selectedStartTime = null;
                                selectedEndTime = null;
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            child: CustomButton(
                              textColor: Colors.white,
                              backgroundColor: Colors.green,
                              icon: Icons.save,
                              text: 'Guardar',
                              fontSize: 12,
                              onPressed: () async {
                                _createProgramacion();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _selectTime(
      BuildContext context, bool isStartTime, StateSetter setModalState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setModalState(() {
        if (isStartTime) {
          selectedStartTime = picked;
        } else {
          selectedEndTime = picked;
        }
      });
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
