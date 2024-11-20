import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../componets/CustomAppBar.dart';
import '../../servicios/antecedentesServices.dart';
import 'AntecedentesPaciente.dart';

class AntecedentesScreen extends StatefulWidget {
  @override
  _AntecedentesScreenState createState() => _AntecedentesScreenState();
}

class _AntecedentesScreenState extends State<AntecedentesScreen> {
  List<Map<String, dynamic>> antecedentes = [];
  List<Map<String, dynamic>> filteredAntecedentes = []; // Lista filtrada
  final TextEditingController _searchController = TextEditingController(); // Controlador de búsqueda
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAntecedentes();
    _searchController.addListener(_filterAntecedentes); // Escucha los cambios en el campo de búsqueda
  }

  // Formato de fecha para mostrar en la tabla
  String _formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // Función para obtener los antecedentes desde la API
  Future<void> _fetchAntecedentes() async {
    try {
      final fetchedAntecedentes = await AntecedentesServices().getAntecedentes();
      setState(() {
        antecedentes = fetchedAntecedentes;
        filteredAntecedentes = List.from(antecedentes); // Inicializamos la lista filtrada
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching antecedentes: $e");
    }
  }

  // Función para filtrar los antecedentes según el texto de búsqueda
  void _filterAntecedentes() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        filteredAntecedentes = List.from(antecedentes); // Si no hay búsqueda, mostramos todos
      } else {
        filteredAntecedentes = antecedentes.where((antecedente) {
          return antecedente['usuario']['nombre'].toLowerCase().contains(query) ||
              antecedente['fecha_apertura'].toLowerCase().contains(query)||antecedente['usuario']['id'].toString().toLowerCase().contains(query) ;
        }).toList(); // Filtra por nombre de usuario o fecha
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Registro de',
        title2: 'Antecedentes',
        icon: Icons.arrow_back_ios_rounded,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Indicador de carga
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(31, 184, 169, 169),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Barra de búsqueda
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Buscar por nombre o fecha',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16,
                              ), // Ajusta el padding
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
                          columnSpacing: 8.0,
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'Usuario ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Nombre Usuario',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Fecha Apertura',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Detalles',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: filteredAntecedentes.map((antecedente) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text(antecedente['usuario']['id'].toString())),
                                DataCell(Text(antecedente['usuario']['nombre'])),
                                DataCell(Text(_formatDate(antecedente['fecha_apertura']))),
                                DataCell(
                                  Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          // Navegar a la pantalla de detalles del antecedente
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AntecedentesPaciente(
                                                id: antecedente['usuario']['id'], // Pasamos el id
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: Colors.blue,
                                          size: 22,
                                        ),
                                      ),
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
            ),
    );
  }
}
