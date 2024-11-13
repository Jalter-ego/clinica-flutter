import 'package:flutter/material.dart';

import '../../componets/CustomAppBar.dart';

class GestionarTriaje extends StatefulWidget {
  @override
  _GestionarTriajeState createState() => _GestionarTriajeState();
}

class _GestionarTriajeState extends State<GestionarTriaje> {
  final Map<String, bool> daysAvailable = {
    'Lunes': false,
    'Martes': false,
    'Miércoles': false,
    'Jueves': false,
    'Viernes': false,
    'Sábado': false,
    'Domingo': false,
  };

  final Map<String, TimeOfDay?> startTimes = {};
  final Map<String, TimeOfDay?> endTimes = {};

  void _selectTime(BuildContext context, String day, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTimes[day] = picked;
        } else {
          endTimes[day] = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Registro de',
        title2: 'Triajes',
        icon: Icons.arrow_back_ios_rounded,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona los días y horarios de triaje:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: daysAvailable.keys.map((day) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(day),
                          Switch(
                            value: daysAvailable[day]!,
                            onChanged: (bool value) {
                              setState(() {
                                daysAvailable[day] = value;
                                if (!value) {
                                  startTimes.remove(day);
                                  endTimes.remove(day);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      if (daysAvailable[day]!)
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => _selectTime(context, day, true),
                              child: Text(
                                  'Inicio: ${startTimes[day]?.format(context) ?? 'No seleccionado'}'),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () => _selectTime(context, day, false),
                              child: Text(
                                  'Fin: ${endTimes[day]?.format(context) ?? 'No seleccionado'}'),
                            ),
                          ],
                        ),
                      const Divider(),
                    ],
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final selectedDays = daysAvailable.entries
                    .where((entry) => entry.value)
                    .map((entry) {
                  final start = startTimes[entry.key]?.format(context) ?? '';
                  final end = endTimes[entry.key]?.format(context) ?? '';
                  return '${entry.key}: $start - $end';
                }).toList();

                print('Días seleccionados: $selectedDays');
              },
              child: const Text('Guardar Configuración'),
            ),
          ],
        ),
      ),
    );
  }
}
