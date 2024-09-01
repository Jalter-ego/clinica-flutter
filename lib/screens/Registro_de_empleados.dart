import 'package:flutter/material.dart';

class EmployeeRegistrationPage extends StatefulWidget {
  const EmployeeRegistrationPage({super.key});

  @override
  _EmployeeRegistrationPageState createState() =>
      _EmployeeRegistrationPageState();
}

class _EmployeeRegistrationPageState extends State<EmployeeRegistrationPage> {
  List<Employee> employees = [
    Employee(
        id: 1, name: 'Administrador De Sistema', specialty: '', isActive: true),
    // Agrega más empleados aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Empleados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Buscar',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 174, 191, 200)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 174, 191, 200)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Acción para agregar un nuevo empleado
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 5),
                      Text(
                        'Nuevo',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Especialidad')),
                    DataColumn(label: Text('Estado')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: employees.map((employee) {
                    return DataRow(
                      cells: [
                        DataCell(Text(employee.name)),
                        DataCell(Text(employee.specialty)),
                        DataCell(
                          Switch(
                            value: employee.isActive,
                            onChanged: (value) {
                              setState(() {
                                employee.isActive = value;
                              });
                            },
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              iconButton(Icons.edit),
                              iconButton(Icons.delete),
                            ],
                          ),
                        ),
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

Widget iconButton(IconData icono) {
  return IconButton(
    icon: Icon(icono),
    onPressed: () {
      // Acción para el botón
    },
  );
}

class Employee {
  final int id;
  final String name;
  final String specialty;
  bool isActive;

  Employee({
    required this.id,
    required this.name,
    required this.specialty,
    required this.isActive,
  });
}
