import 'package:flutter/material.dart';
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';

class Citas extends StatefulWidget {
  const Citas({super.key});

  @override
  _Citas createState() => _Citas();
}

class _Citas extends State<Citas> {
  final List<Map<String, dynamic>> citas = [
    {
      'N': 1,
      "Fecha": "20/10/2024",
      "Hora": "14:00",
      "Paciente": "",
      "Empleado": "Consulta Externa"
    },
    {
      'N': 2,
      "Fecha": "19/10/2024",
      "Hora": "6:00",
      "Paciente": "Consulta Externa",
      "Empleado": "Consulta Externa"
    },
    {
      'N': 3, 
      "Fecha": "10/11/2024",
      "Hora": "13:30",
      "Paciente": "Consulta Externa",
      "Empleado": "Consulta Externa"
    
    },
    {
      'N': 4,
      "Fecha": "11/11/2089",
      "Hora": "10:25",
      "Paciente": "Consulta Externa",
      "Empleado": "Consulta Externa"
    },
  ];
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Registro de',
        title2: 'Citas',
        icon: Icons.arrow_back_ios_rounded,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 120,
                height: 40,
                child: CustomButton(
                  textColor: Colors.white,
                  backgroundColor: Colors.green,
                  icon: Icons.add,
                  text: 'Nuevo',
                  fontSize: 14,
                  onPressed: () {},
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DataTable(
                  columnSpacing: 8.0,
                  columns: const <DataColumn>[
                    DataColumn(
                      label: SizedBox(
                        width: 10,
                        child: Text(
                          'N',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Fecha',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Hora',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Paciente',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Empleado',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          'Accion',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: citas.map((cita) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          SizedBox(
                            width: 15,
                            child: Text(
                              cita['N'].toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 90,
                            child: Text(
                              cita['Fecha'],
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.clip,
                              softWrap: true,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 90,
                            child: Text(
                              cita['Hora'],
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.clip,
                              softWrap: true,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 90,
                            child: Text(
                              cita['Paciente'],
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.clip,
                              softWrap: true,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 90,
                            child: Text(
                              cita['Empleado'],
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.clip,
                              softWrap: true,
                            ),
                          ),
                        ),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_square,
                                  color: Colors.blue),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {},
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
