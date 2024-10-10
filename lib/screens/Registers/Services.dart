import 'package:flutter/material.dart';
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  _Services createState() => _Services();
}

class _Services extends State<Services> {
  final List<Map<String, dynamic>> services = [
    {
      'N': 1,
      'description': 'CE Psicologia',
      "tipo atencion": "Consulta Externa"
    },
    {
      'N': 2,
      'description': 'CE Nutricion',
      "tipo atencion": "Consulta Externa"
    },
    {'N': 3, 'description': 'CE Terapia', "tipo atencion": "Consulta Externa"},
    {
      'N': 4,
      'description': 'Topico Procedimiento',
      "tipo atencion": "Emergencias"
    },
  ];
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Registro de',
        title2: 'Servicios',
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
                          'Descripción',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Tipo de Atencion',
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
                          'Acción',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: services.map((service) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          SizedBox(
                            width: 15,
                            child: Text(
                              service['N'].toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 90,
                            child: Text(
                              service['description'],
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
                              service['tipo atencion'],
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
