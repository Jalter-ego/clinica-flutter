import 'package:flutter/material.dart';
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';

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
                labelText: 'Nombre del Paciente',
                hintText: 'Ingrese el nombre del paciente',
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _especialistaController,
                labelText: 'Nombre del Especialista',
                hintText: 'Ingrese el nombre del especialista',
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _servicioController,
                labelText: 'Servicio',
                hintText: 'Ingrese el servicio',
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
                  onPressed: () {
                    // Lógica para guardar la cita
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
