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
            borderRadius:
                BorderRadius.circular(16.0), // Ajusta el radio de los bordes
          ),
          child: Container(
            width: 500, // Ajusta el ancho del modal aquí
            padding: const EdgeInsets.all(16.0), // Agrega padding al contenido
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
              children: [
                const Text(
                  'Nuevo Departamento',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                    height: 16), // Espacio entre el título y el campo
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Descripción del departamento',
                  ),
                ),
                const SizedBox(height: 16), // Espacio antes de los botones
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Espacio entre los botones
                  children: [
                    SizedBox(
                      child: CustomButton(
                        textColor: Colors.white,
                        backgroundColor: Colors.red,
                        icon: Icons.cancel, // Cambié el icono a cancelar
                        text: 'Cancelar',
                        fontSize: 12,
                        onPressed: () {
                          _descriptionController
                              .clear(); // Limpiar el campo de texto
                          Navigator.of(context).pop(); // Cierra el modal
                        },
                      ),
                    ),
                    const SizedBox(width: 8), // Espacio entre los botones
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
                          Navigator.of(context).pop(); // Cierra el modal
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
                  onPressed: _showModal, // Muestra el modal al presionar
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.all(16.0), // Espacio alrededor de la tabla
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Borde de la tabla
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DataTable(
                  columnSpacing: 10.0, // Ajustar espacio entre columnas
                  columns: const <DataColumn>[
                    DataColumn(
                      label: SizedBox(
                        width: 30, // Reducir el ancho de la columna N
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
                            width: 15, // Ancho más pequeño para N
                            child: Text(
                              department['N'].toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 150, // Limitar el ancho de la descripción
                            child: Text(
                              department['description'],
                              style: const TextStyle(fontSize: 12),
                              overflow:
                                  TextOverflow.clip, // Clip si es necesario
                              softWrap: true, // Permitir salto de línea
                            ),
                          ),
                        ),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // Lógica para editar
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Lógica para eliminar
                              },
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
