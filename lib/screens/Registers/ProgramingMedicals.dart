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
  List<Map<String, dynamic>> specialists = [];
  bool isLoading = true;
  int? selectedSpecialistId;
  Set<DateTime> selectedDates = {};

  @override
  void initState() {
    super.initState();
    _fetchPrograming();
  }

  Future<void> _fetchPrograming() async {
    try {
      final fetchedSpecialists =
          await ProgramingMedicalsServices().getSpecialists();
      setState(() {
        specialists = fetchedSpecialists;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching departments: $e");
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
                          border: Border.all(color: Colors.grey),
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
                            return DataRow(
                              selected:
                                  selectedSpecialistId == specialist['id'],
                              onSelectChanged: (selected) {
                                setState(() {
                                  selectedSpecialistId =
                                      selected! ? specialist['id'] : null;
                                });
                              },
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
                                  SizedBox(
                                    width: 150,
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
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
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
                  ],
                ),
              ),
            ),
    );
  }
}
