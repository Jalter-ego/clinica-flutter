import 'package:flutter/material.dart';
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';

class Specialties extends StatefulWidget {
  const Specialties({super.key});

  @override
  _Specialties createState() => _Specialties();
}

class _Specialties extends State<Specialties> {
  final List<Map<String, dynamic>> specialties = [
    {'N': 1, 'description': 'Cardiologia'},
    {
      'N': 2,
      'description': 'Medicina General',
    }
  ];
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Registro de',
        title2: 'Especialidades',
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
                  columnSpacing: 10,
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
                  rows: specialties.map((specialty) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          SizedBox(
                            width: 15,
                            child: Text(
                              specialty['N'].toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 150,
                            child: Text(
                              specialty['description'],
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

  void _showModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 5, // Sombra del diálogo
          child: Container(
            width: 650, // Establece el ancho deseado
            height: 450, // Establece la altura deseada
            decoration: BoxDecoration(
              color: Colors.white, // Color de fondo
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Título del Diálogo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                    'Contenido del diálogo con dimensiones personalizadas.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
