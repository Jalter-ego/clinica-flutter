import 'package:OptiVision/componets/RegisterInput.dart';
import 'package:flutter/material.dart';
import '../../componets/CustomAppBar.dart';
import '../../componets/CustomButtom.dart';
import '../../servicios/citasServices.dart';
import '../../servicios/paymentServices.dart'; // Importar el servicio de pagos
import '../Registers/Citas.dart'; // Importar la pantalla de citas

class CitasRegister extends StatefulWidget {
  const CitasRegister({super.key});

  @override
  _CitasRegisterState createState() => _CitasRegisterState();
}

class _CitasRegisterState extends State<CitasRegister> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _especialistaController = TextEditingController();
  final TextEditingController _servicioController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _comentariosController = TextEditingController();

  final PaymentServices _paymentServices =
      PaymentServices(); // Inicializamos el servicio de pago

  String formatFecha(String fecha) {
    List<String> partes = fecha.split('/');
    if (partes.length == 3) {
      // Reordenar partes para formar YYYY-MM-DD
      return '${partes[2]}-${partes[1]}-${partes[0]}';
    }
    return fecha; // Retornar fecha sin cambio si no cumple el formato esperado
  }

  Future<void> _handlePaymentAndCita() async {
    try {
      // 1. Crear el PaymentIntent en tu backend
      String clientSecret =
          await _paymentServices.createPaymentIntent(5000, 'usd');

      // 2. Presentar la hoja de pago
      await _paymentServices.presentPaymentSheet(clientSecret);

      // 3. Si el pago es exitoso, proceder con la creación de la cita
      String fechaFormateada = formatFecha(_fechaController.text);
      bool success = await CitasServices().crearCita(
        context: context,
        usuarioId: int.parse(_usuarioController.text),
        especialistaId: int.parse(_especialistaController.text),
        servicioId: int.parse(_servicioController.text),
        fecha: fechaFormateada,
        hora: _horaController.text,
        comentario: _comentariosController.text,
      );

      if (success) {
        // Redirigir a la pantalla de citas y mostrar un mensaje de éxito
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const Citas()), // Redirige a la pantalla de Citas
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cita registrada exitosamente.")),
        );
      } else {
        // Mostrar mensaje de error si la cita no se pudo registrar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("No se pudo registrar la cita. Inténtalo de nuevo.")),
        );
      }
    } catch (e) {
      // Manejar errores en el pago o la creación de la cita
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en el proceso: $e")),
      );
    }
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
              const Text(
                'Id del Usuario',
                style: TextStyle(fontSize: 14),
              ),
              RegisterInput(
                nombreController: _usuarioController,
                hintText: 'Ingrese el Id del Usuario (Paciente)',
              ),
              const SizedBox(height: 16),
              const Text(
                'Id del Especialista',
                style: TextStyle(fontSize: 14),
              ),
              RegisterInput(
                nombreController: _especialistaController,
                hintText: 'Ingrese el Id del especialista',
              ),
              const SizedBox(height: 16),
              const Text(
                'Id del Servicio',
                style: TextStyle(fontSize: 14),
              ),
              RegisterInput(
                nombreController: _servicioController,
                hintText: 'Ingrese el Id del servicio',
              ),
              const SizedBox(height: 16),
              const Text(
                'Fecha',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _fechaController,
                labelText: '',
                hintText: 'DD/MM/YYYY',
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              const Text(
                'Hora',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _horaController,
                labelText: '',
                hintText: 'HH:MM',
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              const Text(
                'Comentarios',
                style: TextStyle(fontSize: 14),
              ),
              RegisterInput(
                nombreController: _comentariosController,
                hintText: 'Ingrese detalles de la Consulta que Realizará',
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
                  onPressed:
                      _handlePaymentAndCita, // Ahora el botón manejará el pago y la creación de la cita
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
