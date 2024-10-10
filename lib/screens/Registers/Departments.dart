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
  final TextEditingController _nombreController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
  }

  Future<void> _fetchDepartments() async {
    try {
      final fetchedDepartments = await DepartmentsServices().fetchDepartments();
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
                        onPressed: _showModal,
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
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {},
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

  void _showModal() {
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
                        controller: _nombreController,
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
                          print(
                              'Descripción guardada: ${_nombreController.text}');
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
}
