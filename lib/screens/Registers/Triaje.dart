import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Necesitarás importar esto para formatear la fecha
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';
import '../../servicios/triajeServices.dart'; // Asegúrate de importar el servicio
import '../../providers/proveedor_usuario.dart';
import 'TriajeDetalles.dart';

class GestionarTriaje extends StatefulWidget {
  @override
  _GestionarTriajeState createState() => _GestionarTriajeState();
}

class _GestionarTriajeState extends State<GestionarTriaje> {
  List<Map<String, dynamic>> triajes = [];
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idUsuarioController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _nivelPrioridadController = TextEditingController();
  final TextEditingController _frecuenciaCardiacaController = TextEditingController();
  final TextEditingController _frecuenciaRespiratoriaController = TextEditingController();
  final TextEditingController _temperaturaController = TextEditingController();
  final TextEditingController _saturacionOxigenoController = TextEditingController();
  final TextEditingController _presionArterialController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _vision_inicial_odController = TextEditingController();
  final TextEditingController _vision_inicial_oiController= TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchTriajes();
  }

  // Función para obtener los triajes desde la API
  Future<void> _fetchTriajes() async {
    try {
      final fetchedTriajes = await TriajeServices().getTriajes();
      setState(() {
        triajes = fetchedTriajes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching triajes: $e");
    }
  }

  String _formatDate(String dateStr) {
    // Parseamos la fecha desde el formato ISO 8601
    DateTime dateTime = DateTime.parse(dateStr);
    // Formateamos la fecha a 'yyyy-MM-dd'
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // Función para mostrar el modal
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
                  controller: _fechaController,
                  decoration: InputDecoration(labelText: 'Fecha (yyyy-MM-dd)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una fecha';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _horaController,
                  decoration: InputDecoration(labelText: 'Hora'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una hora';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nivelPrioridadController,
                  decoration: InputDecoration(labelText: 'Nivel de Prioridad'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nivel de prioridad';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _frecuenciaCardiacaController,
                  decoration: InputDecoration(labelText: 'Frecuencia Cardiaca'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la frecuencia cardiaca';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _frecuenciaRespiratoriaController,
                  decoration: InputDecoration(labelText: 'Frecuencia Respiratoria'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la frecuencia respiratoria';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _temperaturaController,
                  decoration: InputDecoration(labelText: 'Temperatura'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la temperatura';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _saturacionOxigenoController,
                  decoration: InputDecoration(labelText: 'Saturación de Oxígeno'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la saturación de oxígeno';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _presionArterialController,
                  decoration: InputDecoration(labelText: 'Presión Arterial'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la presión arterial';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una descripción';
                    }
                    return null;
                  },
                ),
                 TextFormField(
                  controller: _vision_inicial_odController,
                  decoration: InputDecoration(labelText: 'Vision inicial od'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un valor';
                    }
                    return null;
                  },
                ),
                 TextFormField(
                  controller: _vision_inicial_oiController,
                  decoration: InputDecoration(labelText: 'Vision incial oi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un valor';
                    }
                    return null;
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
                    if (_formKey.currentState?.validate() ?? false) {
                      // Si el formulario es válido, proceder a crear el triaje
                      TriajeServices().crearTriaje(
                        usuarioId: int.parse(_idUsuarioController.text),
                        fecha: _fechaController.text,
                        hora: _horaController.text,
                        nivelPrioridad: _nivelPrioridadController.text,
                        frecuenciaCardiaca: double.parse(_frecuenciaCardiacaController.text),
                        frecuenciaRespiratoria: double.parse(_frecuenciaRespiratoriaController.text),
                        temperatura: double.parse(_temperaturaController.text),
                        saturacionOxigeno: double.parse(_saturacionOxigenoController.text),
                        presionArterial: _presionArterialController.text,
                        descripcion: _descripcionController.text,
                        vision_inicial_od:double.parse(_vision_inicial_odController.text),
                        vision_inicial_oi:double.parse(_vision_inicial_oiController.text),
                      ).then((success) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Triaje creado exitosamente')),
                          );
                          _fetchTriajes(); // Recargar la lista de triajes
                          Navigator.of(context).pop(); // Cerrar el modal
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al crear el triaje')),
                          );
                        }
                      });
                    }
                  },
                  child: Text('Guardar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el modal
                  },
                  child: Text('Cancelar'),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
 void _eliminarTriaje(int id) {
  TriajeServices().eliminarTriaje(id).then((success) {
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Triaje eliminado exitosamente')),
      );
      _fetchTriajes(); // Recargar la lista de triajes después de la eliminación
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el triaje')),
      );
    }
  });
}
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    String ci = userProvider.ci ?? '';

    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Registro de',
        title2: 'Triajes',
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
                          onPressed: _showCreateTriajeModal, // Llamar al modal
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
                                'Usuario ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Prioridad',
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
                                'Acciones',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: triajes.map((triaje) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(Text(triaje['id'].toString()), 
                                onTap: () {
        // Aquí vamos a navegar a la pantalla de detalles
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TriajeDetailsScreen(
              id: triaje['id'],
              usuarioId: triaje['usuario_id'],
              nivelPrioridad: triaje['nivel_prioridad'],
              fecha: _formatDate(triaje['fecha']),
              hora: triaje['hora'],
              frecuenciaCardiaca: triaje['frecuencia_cardiaca'].toDouble(),
              frecuenciaRespiratoria: triaje['frecuencia_respiratoria'].toDouble(),
              temperatura: double.tryParse(triaje['temperatura'].toString()) ?? 0.0,
              saturacionOxigeno: double.tryParse(triaje['saturacion_oxigeno'].toString()) ?? 0.0,
              presionArterial: triaje['presion_arterial'],
              descripcion: triaje['descripcion'],
              visionInicialOd: double.tryParse(triaje['vision_inicial_od'].toString()) ?? 0.0,
              visionInicialOi: double.tryParse(triaje['vision_inicial_oi'].toString()) ?? 0.0,
            ),
          ),
        );
      },
       ),
                                DataCell(Text(triaje['usuario_id'].toString()),
                                 onTap: () {
        // Aquí vamos a navegar a la pantalla de detalles
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TriajeDetailsScreen(
              id: triaje['id'],
              usuarioId: triaje['usuario_id'],
              nivelPrioridad: triaje['nivel_prioridad'],
              fecha: _formatDate(triaje['fecha']),
              hora: triaje['hora'],
              frecuenciaCardiaca: triaje['frecuencia_cardiaca'].toDouble(),
              frecuenciaRespiratoria: triaje['frecuencia_respiratoria'].toDouble(),
              temperatura: double.tryParse(triaje['temperatura'].toString()) ?? 0.0,
              saturacionOxigeno: double.tryParse(triaje['saturacion_oxigeno'].toString()) ?? 0.0,
              presionArterial: triaje['presion_arterial'],
              descripcion: triaje['descripcion'],
              visionInicialOd: double.tryParse(triaje['vision_inicial_od'].toString()) ?? 0.0,
              visionInicialOi: double.tryParse(triaje['vision_inicial_oi'].toString()) ?? 0.0,
            ),
          ),
        );
      },
                                ),
                                DataCell(Text(triaje['nivel_prioridad']),
                                 onTap: () {
        // Aquí vamos a navegar a la pantalla de detalles
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TriajeDetailsScreen(
              id: triaje['id'],
              usuarioId: triaje['usuario_id'],
              nivelPrioridad: triaje['nivel_prioridad'],
              fecha: _formatDate(triaje['fecha']),
              hora: triaje['hora'],
              frecuenciaCardiaca: triaje['frecuencia_cardiaca'].toDouble(),
              frecuenciaRespiratoria: triaje['frecuencia_respiratoria'].toDouble(),
              temperatura: double.tryParse(triaje['temperatura'].toString()) ?? 0.0,
              saturacionOxigeno: double.tryParse(triaje['saturacion_oxigeno'].toString()) ?? 0.0,
              presionArterial: triaje['presion_arterial'],
              descripcion: triaje['descripcion'],
              visionInicialOd: double.tryParse(triaje['vision_inicial_od'].toString()) ?? 0.0,
              visionInicialOi: double.tryParse(triaje['vision_inicial_oi'].toString()) ?? 0.0,
            ),
          ),
        );
      },
                                ),
                                DataCell(Text(_formatDate(triaje['fecha'])),
                                 onTap: () {
        // Aquí vamos a navegar a la pantalla de detalles
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TriajeDetailsScreen(
              id: triaje['id'],
              usuarioId: triaje['usuario_id'],
              nivelPrioridad: triaje['nivel_prioridad'],
              fecha: _formatDate(triaje['fecha']),
              hora: triaje['hora'],
              frecuenciaCardiaca: triaje['frecuencia_cardiaca'].toDouble(),
              frecuenciaRespiratoria: triaje['frecuencia_respiratoria'].toDouble(),
              temperatura: double.tryParse(triaje['temperatura'].toString()) ?? 0.0,
              saturacionOxigeno: double.tryParse(triaje['saturacion_oxigeno'].toString()) ?? 0.0,
              presionArterial: triaje['presion_arterial'],
              descripcion: triaje['descripcion'],
              visionInicialOd: double.tryParse(triaje['vision_inicial_od'].toString()) ?? 0.0,
              visionInicialOi: double.tryParse(triaje['vision_inicial_oi'].toString()) ?? 0.0,
            ),
          ),
        );
      },), // Formateo de la fecha
                                DataCell(
                                  Row(
                                    children: [
                                      // Icono de Editar
                                     /* GestureDetector(
                                        onTap: () {
                                          // Aquí agregarás la funcionalidad para editar el triaje
                                          print('Editar triaje ${triaje['id']}');
                                        },
                                        child: const Icon(Icons.edit, color: Colors.blue, size: 22),
                                      ),
                                      */
                                      const SizedBox(width: 10), // Espacio entre los iconos
                                      // Icono de Eliminar
                                      GestureDetector(
                                        onTap: () {
                                          // Aquí agregarás la funcionalidad para eliminar el triaje
                                           _eliminarTriaje(triaje['id']);
                                          print('Eliminar triaje ${triaje['id']}');
                                        },
                                        child: const Icon(Icons.delete, color: Colors.red, size: 22),
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
