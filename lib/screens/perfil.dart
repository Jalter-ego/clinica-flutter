import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/login.dart';
import 'package:flutter_frontend/servicios/autenticacion_Services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class PerfilScreen extends StatefulWidget{
  const PerfilScreen({super.key});
  @override
  _PerfilScreenState createState()=> _PerfilScreenState();
}



class _PerfilScreenState extends State<PerfilScreen> {
  static const storage = FlutterSecureStorage();

  String? _nombre;
  String? _correo;
  @override
  void initState() {
    super.initState();
    _cargarNombre();
  }

  Future<void> _cargarNombre() async {
    final nombre = await storage.read(key: 'nombre');
    final correo = await storage.read(key: 'email');
    setState(() {
      _nombre = nombre;
      _correo = correo;
    });
  }
  Future<void> _cerrarSesion() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
    await storage.delete(key: 'nombre');


    // Redirigir a la página de inicio de sesión
    Get.offAll(() => const LoginPage());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        backgroundColor: const Color(0xFF3E69FE),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto de perfil
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/usuarioLogo.png'), 
            ),
            const SizedBox(height: 20),
            // Información personal
            Text(
               _nombre ?? 'Usuario',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _correo ?? 'Correo',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Opciones de cuenta
            _buildProfileOption(
              context,
              icon: Icons.calendar_today,
              label: 'Mis Citas',
              onTap: () {
                // Navegar a la sección de citas
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.lock,
              label: 'Cambiar Contraseña',
              onTap: () {
                // Navegar a la sección de cambio de contraseña
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.info,
              label: 'Historial Médico',
              onTap: () {
                // Navegar al historial médico
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.settings,
              label: 'Configuración de la Cuenta',
              onTap: () {
                // Navegar a la configuración de la cuenta
              },
            ),
            const SizedBox(height: 40),
            // Botón de cerrar sesión
            ElevatedButton.icon(
              onPressed: () {
                 _cerrarSesion();
              },
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para crear las opciones del perfil
  Widget _buildProfileOption(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 14, 71, 194)),
      title: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
