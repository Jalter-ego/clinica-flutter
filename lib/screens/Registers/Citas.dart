import 'package:flutter/material.dart';
import 'package:OptiVision/screens/Registers/CitasRegister.dart';
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';
import '../../servicios/citasServices.dart'; // Importa tu servicio
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Citas extends StatefulWidget {
  const Citas({super.key});

  @override
  _Citas createState() => _Citas();
}

class _Citas extends State<Citas> {
  List<Map<String, dynamic>> citas = [];
  List<Map<String, dynamic>> filteredCitas = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    _fetchCitas(); // Llama a la API para obtener las citas
    _searchController.addListener(_filterCitas);
  }

  
  // Método para obtener citas desde el servicio
  Future<void> _fetchCitas() async {
    try {
      List<Map<String, dynamic>>? citasFromApi =
          await CitasServices().listarCitas(context: context);

      if (citasFromApi != null) {
        setState(() {
          citas = citasFromApi; // Asignamos los datos de la API
          filteredCitas = List.from(citas); // Inicializamos la lista filtrada
          isLoading = false; // Dejamos de cargar
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Si hay error, dejamos de cargar
      });
    }
  }
  
  Future<void> _generatePDF() async {
  final pdf = pw.Document();
  
  // Añadir contenido al PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Reporte de Citas', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.TableHelper.fromTextArray(
              headers: ['Fecha', 'Hora', 'Paciente', 'Especialista'],
              data: filteredCitas.map((cita) {
                return [
                  cita['fecha'],
                  cita['hora'],
                  cita['paciente'],
                  cita['especialista'],
                ];
              }).toList(),
            ),
          ],
        );
      },
    ),
  );

  try {
    // Guardar el PDF en el dispositivo
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/reporte_citas.pdf');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF generado en ${file.path}')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al generar el PDF: $e')),
    );
  }
}



  void _filterCitas() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        filteredCitas = List.from(citas);
      } else {
        filteredCitas = citas.where((cita) {
          return cita['paciente'].toLowerCase().contains(query) ||
              cita['fecha'].toLowerCase().contains(query) ||
              cita['hora'].toLowerCase().contains(query) ||
              cita['especialista'].toLowerCase().contains(query);
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
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Indicador de carga mientras obtenemos datos
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Barra de búsqueda
                        // Espacio entre la búsqueda y el botón
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: CustomButton(
                            textColor: Colors.white,
                            backgroundColor: Colors.green,
                            icon: Icons.add,
                            text: 'Nuevo',
                            fontSize: 14,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CitasRegister(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Buscar por paciente, fecha, hora...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 16), // Ajusta el padding vertical
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DataTable(
                        columnSpacing: 0.0,
                        columns: const <DataColumn>[
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
                              'Especialista',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: filteredCitas.map((cita) {
                          DateTime fecha = DateTime.parse(cita['fecha']);
                          String formattedDate =
                              '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text(formattedDate)),
                              DataCell(Text(cita['hora'])),
                              DataCell(Text(cita['paciente'])),
                              DataCell(Text(cita['especialista'])),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  // Botón para generar reportes
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                           await _generatePDF(); 
                        },
                        icon: const Icon(Icons.picture_as_pdf,
                            color: Colors.white),
                        label: const Text(
                          'Generar Reporte',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
