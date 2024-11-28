import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../servicios/diagnosticoServices.dart';
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';
import '../../providers/proveedor_usuario.dart';
import 'DiagnosticoDetail.dart';

class GestionarDiagnosticos extends StatefulWidget {
  const GestionarDiagnosticos({super.key});

  @override
  _GestionarDiagnosticosState createState() => _GestionarDiagnosticosState();
}

class _GestionarDiagnosticosState extends State<GestionarDiagnosticos> {
  List<Map<String, dynamic>> diagnosticos = [];
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _consultaIdController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _tipoDiagnosticoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDiagnosticos();
  }

  // Función para obtener los diagnósticos desde la API
  Future<void> _fetchDiagnosticos() async {
    try {
      final fetchedDiagnosticos = await DiagnosticoServices().getDiagnosticos();
      setState(() {
        diagnosticos = fetchedDiagnosticos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching diagnosticos: $e");
    }
  }

  String _formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  void _showCreateDiagnosticoModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nuevo Diagnóstico'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _consultaIdController,
                    decoration: const InputDecoration(labelText: 'Consulta ID'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el ID de la consulta';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la descripción';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _tipoDiagnosticoController,
                    decoration: const InputDecoration(labelText: 'Tipo Diagnóstico'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el tipo de diagnóstico';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cerrar el modal
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Si el formulario es válido, proceder a crear el diagnóstico
                        DiagnosticoServices().crearDiagnostico(
                          consultaId: int.parse(_consultaIdController.text),
                          descripcion: _descripcionController.text,
                          tipoDiagnostico: _tipoDiagnosticoController.text,
                        ).then((success) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Diagnóstico creado exitosamente')),
                            );
                            _fetchDiagnosticos(); // Recargar la lista de diagnósticos
                            Navigator.of(context).pop(); // Cerrar el modal
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Error al crear el diagnóstico')),
                            );
                          }
                        });
                      }
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    String ci = userProvider.ci ?? '';

    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Registro de',
        title2: 'Diagnósticos',
        icon: Icons.arrow_back_ios_rounded,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
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
                      padding: const EdgeInsets.all(22.0),
                      child: SizedBox(
                        width: 120,
                        height: 40,
                        child: CustomButton(
                          textColor: Colors.white,
                          backgroundColor: Colors.green,
                          icon: Icons.add,
                          text: 'Nuevo',
                          fontSize: 14,
                          onPressed: _showCreateDiagnosticoModal, // Llamar al modal de crear diagnóstico
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 8.0,
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'ID',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Consulta ID',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Descripción',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Tipo Diagnóstico',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Fecha',
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
                            rows: diagnosticos.map((diagnostico) {
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(diagnostico['id'].toString())),
                                  DataCell(Text(diagnostico['consulta_id'].toString())),
                                  DataCell(Text(diagnostico['descripcion'])),
                                  DataCell(Text(diagnostico['tipo_diagnostico'])),
                                  DataCell(Text(_formatDate(diagnostico['fecha']))),
                                  DataCell(
                                    Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DiagnosticoDetail(
                                                  id: diagnostico['id'],
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
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
