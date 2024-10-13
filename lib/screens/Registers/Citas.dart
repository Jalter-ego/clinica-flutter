import 'package:flutter/material.dart';
import 'package:OptiVision/screens/Registers/CitasRegister.dart';
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
      "Paciente": "Roberto Deniro",
      "Empleado": "Dr. Marcelo Camacho"
    },
    {
      'N': 2,
      "Fecha": "19/10/2024",
      "Hora": "6:00",
      "Paciente": "Alpa Chino",
      "Empleado": "Dra Antonieta"
    },
    {
      'N': 3,
      "Fecha": "10/11/2024",
      "Hora": "13:30",
      "Paciente": "Brad Pitt Quispe",
      "Empleado": "Dr. Michael Jackson"
    },
    {
      'N': 4,
      "Fecha": "11/11/2089",
      "Hora": "10:25",
      "Paciente": "Cristiano Ronaldo",
      "Empleado": "Dra. Leonela Messi"
    },
  ];

  List<Map<String, dynamic>> filteredCitas = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCitas = List.from(citas);
    _searchController.addListener(_filterCitas);
  }

  void _filterCitas() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        filteredCitas = List.from(citas);
      } else {
        filteredCitas = citas.where((cita) {
          return cita['Paciente'].toLowerCase().contains(query) ||
              cita['Fecha'].toLowerCase().contains(query) ||
              cita['Hora'].toLowerCase().contains(query) ||
              cita['Empleado'].toLowerCase().contains(query);
        }).toList();
      }
    });
  }

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
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: CustomButton(
                      textColor: Colors.white,
                      backgroundColor: Colors.green,
                      icon: Icons.add,
                      text: 'Nuevo',
                      fontSize: 14,
                      onPressed: () { Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CitasRegister(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Barra de búsqueda
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar por paciente, fecha, hora...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
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
                  columnSpacing: 0.0,
                  columns: const <DataColumn>[
                    DataColumn(
                      label: SizedBox(
                        width: 10,
                        child: Text(
                          'N',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Fecha',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Hora',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Paciente',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Empleado',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: filteredCitas.map((cita) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(cita['N'].toString())),
                        DataCell(Text(cita['Fecha'])),
                        DataCell(Text(cita['Hora'])),
                        DataCell(Text(cita['Paciente'])),
                        DataCell(Text(cita['Empleado'])),
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
