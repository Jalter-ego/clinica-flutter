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
      "Paciente": "Roberto Deniro",
      "Empleado": "Dr. Marcelo Camacho"
    },
    {
      'N': 2,
      "Fecha": "19/10/2024",
      "Hora": "6:00",
      "Paciente": "Alpa Chino",
      "Empleado": "Dra Antonieta "
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
        // Inicializa filteredCitas con todas las citas
        filteredCitas = List.from(citas);
        _searchController.addListener(_filterCitas);
      }

      void _filterCitas() {
  setState(() {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      // Si el campo de búsqueda está vacío, muestra todas las citas
      filteredCitas = citas;
    } else {
      // Filtra la lista de citas según el nombre del paciente
      filteredCitas = citas
          .where((cita) =>
              cita['Paciente'].toLowerCase().contains(query))
          .toList();
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
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Barra de búsqueda
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar por paciente',
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
                        padding: EdgeInsets.only(),
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
                        padding: EdgeInsets.only(),
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
                        padding: EdgeInsets.only(),
                        child: Text(
                          'Empleado',
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
                            width: 40,
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
