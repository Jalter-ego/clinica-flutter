import 'package:flutter/material.dart';
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';

class Departaments extends StatefulWidget {
  const Departaments({super.key});

  @override
  _Departaments createState() => _Departaments();
}

class _Departaments extends State<Departaments> {
  // Lista simulada de datos para la tabla
  final List<Map<String, dynamic>> departments = [
    {'N': 1, 'description': 'Cirugia'},
    {
      'N': 2,
      'description': 'Medicina',
    },
    {'N': 3, 'description': 'Pediatria'},
    {'N': 4, 'description': 'Limpieza'},
  ];
  final TextEditingController _descriptionController = TextEditingController();

  void _showModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nuevo Departamento',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Descripción del departamento',
                  ),
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
                          _descriptionController.clear();
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
                        onPressed: () {
                          print(
                              'Descripción guardada: ${_descriptionController.text}');
                          Navigator.of(context).pop();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Registro de',
        title2: 'Departamentos',
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
                  onPressed: _showModal,
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
                      label: Text(
                        'Acción',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  rows: departments.map((department) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          SizedBox(
                            width: 15,
                            child: Text(
                              department['N'].toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 150,
                            child: Text(
                              department['description'],
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.clip,
                              softWrap: true,
                            ),
                          ),
                        ),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
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
