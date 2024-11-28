import 'package:OptiVision/servicios/specialtiesServices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';
import '../../providers/proveedor_usuario.dart';
import '../../servicios/autenticacion_Services.dart';
import '../../servicios/notificationServices.dart';

class Specialties extends StatefulWidget {
  const Specialties({super.key});

  @override
  _Specialties createState() => _Specialties();
}

class _Specialties extends State<Specialties> {
  List<Map<String, dynamic>> specialties = [];
  final AutenticacionServices authService = AutenticacionServices();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _tiempoController = TextEditingController();
  String ci = '';

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchDepartments();
  }

  void _createSpecialty() async {
    String nombre = _nombreController.text.trim();
    int? tiempo = int.tryParse(_tiempoController.text.trim());
    if (tiempo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('El tiempo estimado debe ser un número válido')),
      );
      return;
    }

    if (nombre.isNotEmpty) {
      try {
        await SpecialtiesServices().createSpecialty(nombre, tiempo);
        final ip = await authService.obtenerIP();
        await authService.insertarBitacora(
          ip: ip,
          ci: ci,
          fecha: DateTime.now(),
          hora: DateTime.now(),
          accion: 'Se creo una especialidad',
          tabla_afectada: 'especialidades',
        );
        _nombreController.clear();
        _tiempoController.clear();
        _fetchDepartments();
        // Notificación
        await mostrarNotificacion(
          titulo: 'Especialidad creada',
          cuerpo: 'La especialidad "$nombre" fue creada exitosamente.',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Especialidad creada exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear el especialidad')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre no puede estar vacío')),
      );
    }
  }

  Future<void> _fetchDepartments() async {
    try {
      final fetchedSpecialties = await SpecialtiesServices().getSpecialties();
      setState(() {
        specialties = fetchedSpecialties;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching specialties: $e");
    }
  }

  void _deleteSpecialty(int specialtieId) async {
    try {
      await SpecialtiesServices().deleteSpecialty(specialtieId);
      final ip = await authService.obtenerIP();
      await authService.insertarBitacora(
        ip: ip,
        ci: ci,
        fecha: DateTime.now(),
        hora: DateTime.now(),
        accion: 'Se elimino una especialidad',
        tabla_afectada: 'especialidades',
      );
      setState(() {
        specialties.removeWhere((dep) => dep['id'] == specialtieId);
      });
      // Notificación
      await mostrarNotificacion(
        titulo: 'Especialidad eliminada',
        cuerpo: 'La especialidad fue eliminada exitosamente.',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  Future<void> _editSpecialty(
      int specialtieId, String newName, int tiempo) async {
    try {
      await SpecialtiesServices().editSpecialty(specialtieId, newName, tiempo);
      final ip = await authService.obtenerIP();
      await authService.insertarBitacora(
        ip: ip,
        ci: ci,
        fecha: DateTime.now(),
        hora: DateTime.now(),
        accion: 'Se edito una especialidad',
        tabla_afectada: 'especialidades',
      );
      setState(() {
        final index =
            specialties.indexWhere((dep) => dep['id'] == specialtieId);
        if (index != -1) {
          specialties[index]['nombre'] = newName;
          specialties[index]['tiempo_estimado'] = tiempo;
        }
      });
      // Notificación
      await mostrarNotificacion(
        titulo: 'Especialidad editada',
        cuerpo: 'La especialidad fue editada exitosamente.',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Especialidad editado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ci = userProvider.ci!;
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Registro de',
        title2: 'Especialidades',
        icon: Icons.arrow_back_ios_rounded,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                        onPressed: _showCreateModal,
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
                        columnSpacing: 20, // Ajusta el espaciado entre columnas
                        columns: const <DataColumn>[
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
                              padding: EdgeInsets.only(left: 2.0),
                              child: Text(
                                'Tiempo',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Acciones',
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
                                  width: 100,
                                  child: Text(
                                    specialty['nombre'],
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.clip,
                                    softWrap: true,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    specialty['tiempo_estimado'].toString(),
                                    textAlign: TextAlign.center,
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
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationModal(
                                          context, specialty['id']);
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

  void _showCreateModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Nueva Especialidad',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nombre de la Especialidad',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 500,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: TextFormField(
                            controller: _nombreController,
                            decoration: const InputDecoration(
                              hintText: 'Escribe el nombre aquí',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Tiempo de la Especialidad',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 500,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: TextFormField(
                            controller: _tiempoController,
                            decoration: const InputDecoration(
                              hintText: 'Escribe el tiempo en minutos aquí',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: CustomButton(
                            textColor: Colors.white,
                            backgroundColor: Colors.red,
                            icon: Icons.cancel,
                            text: 'Cancelar',
                            fontSize: 12,
                            onPressed: () {
                              _nombreController.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          child: CustomButton(
                            textColor: Colors.white,
                            backgroundColor: Colors.green,
                            icon: Icons.save,
                            text: 'Guardar',
                            fontSize: 12,
                            onPressed: () {
                              _createSpecialty();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  void _showDeleteConfirmationModal(BuildContext context, int departmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Eliminación',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: const Text(
              '¿Estás seguro de que deseas eliminar esta especialidad?'),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                child: CustomButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  textColor: Colors.white,
                  backgroundColor: Colors.blue,
                  text: 'Cancelar',
                ),
              ),
              SizedBox(
                child: CustomButton(
                  onPressed: () {
                    _deleteSpecialty(departmentId);
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Colors.red,
                  text: 'Eliminar',
                  textColor: Colors.white,
                ),
              ),
            ]),
          ],
        );
      },
    );
  }
}
