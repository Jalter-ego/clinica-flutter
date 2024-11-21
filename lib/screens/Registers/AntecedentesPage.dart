import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';
import '../../servicios/antecedentesServices.dart';
import 'AntecedentesPaciente.dart';
import 'CitasRegister.dart';

class AntecedentesScreen extends StatefulWidget {
  @override
  _AntecedentesScreenState createState() => _AntecedentesScreenState();
}

class _AntecedentesScreenState extends State<AntecedentesScreen> {
  List<Map<String, dynamic>> antecedentes = [];
  List<Map<String, dynamic>> filteredAntecedentes = []; // Lista filtrada
  final TextEditingController _searchController = TextEditingController(); 


  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idUsuarioController = TextEditingController();
  final TextEditingController _tipoAntecedenteController = TextEditingController();
  final TextEditingController _descripcionController= TextEditingController();
  final TextEditingController _especifico1Controller = TextEditingController();
  final TextEditingController _especifico2Controller = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _importanteController = TextEditingController();
  bool _isImportant=false;
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
   void _showCreateTriajeModal() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Nuevo Triaje'),
        content: SingleChildScrollView( // Agregamos el SingleChildScrollView
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _idUsuarioController,
                  decoration: InputDecoration(labelText: 'ID Usuario'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un ID de usuario';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _tipoAntecedenteController,
                  decoration: InputDecoration(labelText: 'Tipo Antecedente'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una tipo';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'Descripcion'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una descripcion';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _especifico1Controller,
                  decoration: InputDecoration(labelText: 'Especifico 1'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese especifico 1';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _especifico2Controller,
                  decoration: InputDecoration(labelText: 'Especifico 2'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese especifico 2';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _fechaController,
                  decoration: InputDecoration(labelText: 'Fecha (yyyy-MM-dd)'),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una fecha';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<bool>(
  value: _isImportant ?? false,  // Valor por defecto, puedes poner `null` si prefieres inicializarlo en nulo.
  decoration: InputDecoration(
    labelText: 'Es Importante',
    border: OutlineInputBorder(),
  ),
  items: [
    DropdownMenuItem<bool>(
      value: true,
      child: Text('Sí'),
    ),
    DropdownMenuItem<bool>(
      value: false,
      child: Text('No'),
    ),
  ],
  onChanged: (bool? value) {
    setState(() {
      _isImportant = value!;
    });
  },
),
                const SizedBox(height: 20), // Espacio adicional antes de los botones
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0), // Espacio extra en la parte inferior
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Alineamos los botones al final
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el modal
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Si el formulario es válido, proceder a crear el triaje
                      AntecedentesServices().crearAntecedente(
                        usuarioId: int.parse(_idUsuarioController.text),
                        tipoAntecedente: _tipoAntecedenteController.text,
                        descripcion: _descripcionController.text,
                        especifico1: _especifico1Controller.text,
                        especifico2: _especifico2Controller.text,
                        fechaEvento: _fechaController.text,
                        esImportante: _isImportant,
                      ).then((success) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Antecedente creado exitosamente')),
                          );
                          _fetchAntecedentes(); // Recargar la lista de triajes
                          Navigator.of(context).pop(); // Cerrar el modal
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al crear el antecedente')),
                          );
                        }
                      });
                    }
                  },
                  child: Text('Guardar'),
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
                          SizedBox(
                          width: 120,
                          height: 40,
                          child: CustomButton(
                            textColor: Colors.white,
                            backgroundColor: Colors.green,
                            icon: Icons.add,
                            text: 'Nuevo',
                            fontSize: 14,
                            onPressed:_showCreateTriajeModal,
                          ),
                        ),
                        const SizedBox(height: 16),
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
