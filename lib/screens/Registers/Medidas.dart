import 'package:OptiVision/screens/Registers/MedidasDetail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Necesitarás importar esto para formatear la fecha
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';
import '../../servicios/medidasServices.dart'; // Importar el servicio de medidas
import '../../providers/proveedor_usuario.dart';

class GestionarMedidas extends StatefulWidget {
  const GestionarMedidas({super.key});

  @override
  _GestionarMedidasState createState() => _GestionarMedidasState();
}

class _GestionarMedidasState extends State<GestionarMedidas> {
  List<Map<String, dynamic>> medidas = [];
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idPacienteController = TextEditingController();
  final TextEditingController _esferaOdController = TextEditingController();
  final TextEditingController _cilindroOdController = TextEditingController();
  final TextEditingController _ejeOdController = TextEditingController();
  final TextEditingController _adicionOdController = TextEditingController();
  final TextEditingController _esferaOiController = TextEditingController();
  final TextEditingController _cilindroOiController = TextEditingController();
  final TextEditingController _ejeOiController = TextEditingController();
  final TextEditingController _adicionOiController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMedidas();
  }

  // Función para obtener las medidas desde la API
  Future<void> _fetchMedidas() async {
    try {
      final fetchedMedidas = await MedidasServices().listarMedidas();
      setState(() {
        medidas = fetchedMedidas;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching medidas: $e");
    }
  }

  String _formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // Función para mostrar el modal de creación de medidas
  void _showCreateMedidaModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nueva Medida'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _idPacienteController,
                    decoration: const InputDecoration(labelText: 'ID Paciente'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el ID del paciente';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _esferaOdController,
                    decoration: const InputDecoration(labelText: 'Esfera OD'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la esfera OD';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cilindroOdController,
                    decoration: const InputDecoration(labelText: 'Cilindro OD'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el cilindro OD';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _ejeOdController,
                    decoration: const InputDecoration(labelText: 'Eje OD'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el eje OD';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _adicionOdController,
                    decoration: const InputDecoration(labelText: 'Adición OD'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la adición OD';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _esferaOiController,
                    decoration: const InputDecoration(labelText: 'Esfera OI'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la esfera OI';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cilindroOiController,
                    decoration: const InputDecoration(labelText: 'Cilindro OI'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el cilindro OI';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _ejeOiController,
                    decoration: const InputDecoration(labelText: 'Eje OI'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el eje OI';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _adicionOiController,
                    decoration: const InputDecoration(labelText: 'Adición OI'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la adición OI';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _fechaController,
                    decoration: const InputDecoration(labelText: 'Fecha'),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la fecha';
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
                        // Si el formulario es válido, proceder a crear la medida
                        MedidasServices().crearMedida(
                          idPaciente: int.parse(_idPacienteController.text),
                          esferaOd: double.parse(_esferaOdController.text),
                          cilindroOd: double.parse(_cilindroOdController.text),
                          ejeOd: int.parse(_ejeOdController.text),
                          adicionOd: double.parse(_adicionOdController.text),
                          esferaOi: double.parse(_esferaOiController.text),
                          cilindroOi: double.parse(_cilindroOiController.text),
                          ejeOi: int.parse(_ejeOiController.text),
                          adicionOi: double.parse(_adicionOiController.text),
                          fecha: _fechaController.text,
                        ).then((success) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Medida creada exitosamente')),
                            );
                            _fetchMedidas(); // Recargar la lista de medidas
                            Navigator.of(context).pop(); // Cerrar el modal
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Error al crear la medida')),
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
        title2: 'Medidas',
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
                          onPressed: _showCreateMedidaModal, // Llamar al modal
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
                                'ID Paciente',
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
                          rows: medidas.map((medida) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text(medida['id'].toString())),
                                DataCell(Text(medida['id_paciente'].toString())),
                                DataCell(Text(_formatDate(medida['fecha']))),
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
                                              builder: (context) =>
                                                  MedidasDetail(
                                                id: medida['id_paciente'], // Pasamos el id
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
