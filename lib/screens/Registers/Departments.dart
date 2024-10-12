import 'package:OptiVision/providers/theme_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';
import '../../servicios/departmentsServices.dart';

class Departaments extends StatefulWidget {
  const Departaments({super.key});

  @override
  _Departaments createState() => _Departaments();
}

class _Departaments extends State<Departaments> {
  List<Map<String, dynamic>> departments = [];
  final TextEditingController _editController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
  }

  void _createDepartment() async {
    String nombre = _editController.text.trim();
    if (nombre.isNotEmpty) {
      try {
        await DepartmentsServices().createDepartment(nombre);
        _editController.clear();
        _fetchDepartments();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Departamento creado exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear el departamento')),
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
      final fetchedDepartments = await DepartmentsServices().getDepartments();
      setState(() {
        departments = fetchedDepartments;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching departments: $e");
    }
  }

  void _deleteDepartment(int departmentId) async {
    try {
      await DepartmentsServices().deleteDepartment(departmentId);
      setState(() {
        departments.removeWhere((dep) => dep['id'] == departmentId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  Future<void> _editDepartment(int departmentId, String newName) async {
    try {
      final response =
          await DepartmentsServices().editDepartment(departmentId, newName);
      setState(() {
        final index =
            departments.indexWhere((dep) => dep['id'] == departmentId);
        if (index != -1) {
          departments[index]['nombre'] = newName;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Departamento editado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Registro de',
        title2: 'Departamentos',
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
                        color: isDark
                            ? const Color(0xFF1E1E1E)
                            : const Color(0xFFF8F9FA),
                        border: Border.all(
                          color: isDark ? Colors.white54 : Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DataTable(
                        columnSpacing: 10.0,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: SizedBox(
                              width: 30,
                              child: Text(
                                'ID',
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
                            label: Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                'Acción',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                        rows: departments.map((department) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(
                                SizedBox(
                                  width: 15,
                                  child: Text(
                                    department['id'].toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    department['nombre'],
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
                                    onPressed: () {
                                      _showEditModal(context, department['id'],
                                          department['nombre']);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationModal(
                                          context, department['id']);
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nuevo Departamento',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descripción del departamento',
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
                        controller: _editController,
                        decoration: const InputDecoration(
                          hintText: 'Escribe la descripción aquí',
                          hintStyle: TextStyle(color: Colors.black26),
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
                          _editController.clear();
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
              '¿Estás seguro de que deseas eliminar este departamento?'),
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
                    _deleteDepartment(departmentId);
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

  void _showEditModal(
      BuildContext context, int departmentId, String currentName) {
    final TextEditingController editController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Editar Departamento',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del departamento'),
              ),
            ],
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
                    String newName = editController.text.trim();
                    if (newName.isNotEmpty) {
                      await _editDepartment(departmentId, newName);
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
