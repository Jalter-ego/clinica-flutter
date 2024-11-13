import 'package:OptiVision/servicios/serviciosEndPoints.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';
import '../../componets/RegisterInput.dart';
import '../../componets/ModalDelete.dart';
import '../../providers/proveedor_usuario.dart';
import '../../servicios/autenticacion_Services.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  _Services createState() => _Services();
}

class _Services extends State<Services> {
  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> departments = [];
  List<Map<String, dynamic>> specialties = [];
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final AutenticacionServices authService = AutenticacionServices();
  bool isLoading = true;
  String ci = '';

  int? selectedDepartmentId;
  int? selectedSpecialtyId;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      final fetchedServices = await ServicesEndPoints().getServices();
      final fetchedDepartments = await ServicesEndPoints().getDepartments();
      final fetchedSpecialties = await ServicesEndPoints().getSpecialties();
      setState(() {
        services = fetchedServices;
        departments = fetchedDepartments;
        specialties = fetchedSpecialties;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching services: $e");
    }
  }

  void _createDepartment() async {
    String nombre = _nombreController.text.trim();
    String descripcion = _descriptionController.text.trim();

    if (nombre.isNotEmpty &&
        selectedDepartmentId != null &&
        selectedSpecialtyId != null) {
      try {
        await ServicesEndPoints().createService(
            nombre, descripcion, selectedDepartmentId!, selectedSpecialtyId!);

        final ip = await authService.obtenerIP();
        await authService.insertarBitacora(
          ip: ip,
          ci: ci,
          fecha: DateTime.now(),
          hora: DateTime.now(),
          accion: 'Se creo un nuevo servicio',
          tabla_afectada: 'servicios',
        );

        _nombreController.clear();
        _descriptionController.clear();
        selectedDepartmentId = null;
        selectedSpecialtyId = null;
        _fetchServices();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Servicio creado exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear el servicio')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
    }
  }

  Future<void> _editService(
      int serviceId, String newName, String newDescription) async {
    try {
      await ServicesEndPoints().editService(serviceId, newName, newDescription);
      final ip = await authService.obtenerIP();
      await authService.insertarBitacora(
        ip: ip,
        ci: ci,
        fecha: DateTime.now(),
        hora: DateTime.now(),
        accion: 'Se edito un nuevo servicio',
        tabla_afectada: 'servicios',
      );
      setState(() {
        final index = services.indexWhere((dep) => dep['id'] == serviceId);
        if (index != -1) {
          services[index]['nombre'] = newName;
          services[index]['descripcion'] = newDescription;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Servicio editado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  void _deleteService(int serviceId) async {
    try {
      await ServicesEndPoints().deleteService(serviceId);
      final ip = await authService.obtenerIP();
      await authService.insertarBitacora(
        ip: ip,
        ci: ci,
        fecha: DateTime.now(),
        hora: DateTime.now(),
        accion: 'Se elimino un nuevo servicio',
        tabla_afectada: 'servicios',
      );
      setState(() {
        services.removeWhere((dep) => dep['id'] == serviceId);
      });
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
        title2: 'Servicios',
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
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(31, 184, 169, 169),
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
                          onPressed: _showCreateModal,
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
                                  'Nombre',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Descripcion',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'Acción',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          rows: services.map((service) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  SizedBox(
                                    width: 15,
                                    child: Text(
                                      service['id'].toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      service['nombre'],
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.clip,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      service['descripcion'],
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.clip,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _showEditModal(
                                                context,
                                                service['id'],
                                                service['nombre'],
                                                service['descripcion']);
                                          },
                                          child: const Icon(Icons.edit_square,
                                              color: Colors.blue, size: 22),
                                        ),
                                        const SizedBox(
                                            width:
                                                4), // Ajustar si es necesario
                                        GestureDetector(
                                          onTap: () {
                                            showDeleteConfirmationModal(
                                              context: context,
                                              itemName: 'servicio',
                                              onDelete: () {
                                                _deleteService(service['id']);
                                              },
                                            );
                                          },
                                          child: const Icon(Icons.delete,
                                              color: Colors.red, size: 22),
                                        ),
                                      ],
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
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Nuevo Servicio',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nombre del Servicio',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          RegisterInput(
                            nombreController: _nombreController,
                            hintText: 'Escribe el nombre aquí',
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Descripción del Servicio',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          RegisterInput(
                              nombreController: _descriptionController,
                              hintText: 'Escribe la descripción aquí'),
                          const SizedBox(height: 16),
                          const Text(
                            'Seleccionar Departamento',
                            style: TextStyle(fontSize: 14),
                          ),
                          DropdownButton<int>(
                            value: selectedDepartmentId,
                            items: departments.map((department) {
                              return DropdownMenuItem<int>(
                                value: department['id'],
                                child: Text(department['nombre']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedDepartmentId = value;
                              });
                            },
                            hint: const Text('Selecciona un departamento'),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Seleccionar Especialidad',
                            style: TextStyle(fontSize: 14),
                          ),
                          DropdownButton<int>(
                            value: selectedSpecialtyId,
                            items: specialties.map((specialty) {
                              return DropdownMenuItem<int>(
                                value: specialty['id'],
                                child: Text(specialty['nombre']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedSpecialtyId = value;
                              });
                            },
                            hint: const Text('Selecciona una especialidad'),
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
                                _descriptionController.clear();
                                _nombreController.clear();
                                selectedDepartmentId = null;
                                selectedSpecialtyId = null;
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
                                _createDepartment();
                                Navigator.of(context).pop();
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
          ),
        );
      },
    );
  }

  void _showEditModal(BuildContext context, int serviceId, String currentName,
      String currentDescription) {
    final TextEditingController editNameController =
        TextEditingController(text: currentName);
    final TextEditingController editDescriptionController =
        TextEditingController(text: currentDescription);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Editar Servicio',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nombre del Servicio',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 2),
                RegisterInput(
                  nombreController: editNameController,
                  hintText: 'Escribe el nombre aquí',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Descripción del Servicio',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 2),
                RegisterInput(
                    nombreController: editDescriptionController,
                    hintText: 'Escribe la descripción aquí'),
              ],
            ),
          ),
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
                  onPressed: () async {
                    String newName = editNameController.text.trim();
                    String newDescription =
                        editDescriptionController.text.trim();
                    if (newName.isNotEmpty) {
                      await _editService(serviceId, newName, newDescription);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('El nombre no puede estar vacío')),
                      );
                    }
                  },
                  backgroundColor: Colors.green,
                  text: 'Guardar',
                  textColor: Colors.white,
                ),
              ),
            ])
          ],
        );
      },
    );
  }
}
