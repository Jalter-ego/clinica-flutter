import 'package:flutter/material.dart';
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';
import '../../servicios/citasServices.dart';

class CitasRegister extends StatefulWidget {
  const CitasRegister({super.key});

  @override
  _CitasRegisterState createState() => _CitasRegisterState();
}

class _CitasRegisterState extends State<CitasRegister> {
  final TextEditingController _pacienteController = TextEditingController();
  final TextEditingController _especialistaController = TextEditingController();
  final TextEditingController _servicioController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _comentariosController = TextEditingController();


  String formatFecha(String fecha) {
  List<String> partes = fecha.split('/');
  if (partes.length == 3) {
    // Reordenar partes para formar YYYY-MM-DD
    return '${partes[2]}-${partes[1]}-${partes[0]}';
  }
  return fecha; // Retornar fecha sin cambio si no cumple el formato esperado
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                controller: _pacienteController,
                labelText: 'Id del Paciente',
                hintText: 'Ingrese el Id del paciente',
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _especialistaController,
                labelText: 'Id del Especialista',
                hintText: 'Ingrese el Id del especialista',
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _servicioController,
                labelText: 'Id delServicio',
                hintText: 'Ingrese el Id del servicio',
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _fechaController,
                labelText: 'Fecha',
                hintText: 'DD/MM/YYYY',
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _horaController,
                labelText: 'Hora',
                hintText: 'HH:MM',
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _comentariosController,
                labelText: 'Comentarios',
                hintText: 'Ingrese detalles de la Consulta que Realizará',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButton(
                  textColor: Colors.white,
                  backgroundColor: Colors.green,
                  icon: Icons.save,
                  text: 'Registrar Cita',
                  fontSize: 16,
                  onPressed: () async {
                     String fechaFormateada = formatFecha(_fechaController.text);
                    bool success = await CitasServices().crearCita(
                      context: context,
                      pacienteId: int.parse(_pacienteController.text),
                      especialistaId: int.parse(_especialistaController.text),
                      servicioId: int.parse(_servicioController.text),
                      fecha: fechaFormateada,
                      hora: _horaController.text,
                      comentario: _comentariosController.text,
                    );

                    if (success) {
                      Navigator.of(context).pop(); // Volver a la pantalla anterior
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método reutilizable para crear campos de texto
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
