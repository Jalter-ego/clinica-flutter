import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';
import '../../providers/theme_Provider.dart';

class Pathologies extends StatefulWidget {
  const Pathologies({super.key});

  @override
  _Pathologies createState() => _Pathologies();
}

class _Pathologies extends State<Pathologies> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    // Datos estáticos para las patologías
    final List<Map<String, dynamic>> pathologies = [
      {"id": 1, "nombre": "Miopía"},
      {"id": 2, "nombre": "Astigmatismo"},
      {"id": 3, "nombre": "Glaucoma"},
      {"id": 4, "nombre": "Cataratas"},
      {"id": 5, "nombre": "Retinopatía diabética"},
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Registro de',
        title2: 'Patologías',
        icon: Icons.arrow_back_ios_rounded,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: isDark
                ? const Color.fromARGB(31, 48, 48, 48)
                : const Color.fromARGB(31, 184, 169, 169),
            borderRadius: BorderRadius.circular(12.0),
          ),
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
                    onPressed: () {
                      _showCreateModal();
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
                            'Nombre',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Acción',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                    rows: pathologies.map((pathology) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(
                            SizedBox(
                              width: 15,
                              child: Text(
                                pathology['id'].toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 120,
                              child: Text(
                                pathology['nombre'],
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
                                onPressed: () {
                                  _showEditModal(context, pathology['id'],
                                      pathology['nombre']);
                                },
                              ),
                              IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {}),
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
      ),
    );
  }

  void _showCreateModal() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nueva Patología'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre de la Patología',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar modal sin guardar
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  // Aquí puedes añadir la lógica para guardar la nueva patología
                  print('Nueva patología: $newName');
                }
                Navigator.of(context).pop(); // Cerrar modal
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditModal(BuildContext context, int id, String currentName) {
    final TextEditingController nameController = TextEditingController();
    nameController.text = currentName; // Precargar el nombre actual

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Patología'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre de la Patología',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar modal sin guardar
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedName = nameController.text.trim();
                if (updatedName.isNotEmpty) {
                  // Aquí puedes añadir la lógica para actualizar la patología
                  print('Patología actualizada: ID $id, Nombre $updatedName');
                }
                Navigator.of(context).pop(); // Cerrar modal
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }
}
