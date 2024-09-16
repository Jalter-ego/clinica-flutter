import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

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
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/perfil.png'), // Coloca aquí la imagen del usuario
            ),
            const SizedBox(height: 20),
            // Información personal
            const Text(
              'Marcelo Camacho',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'marcelo.camacho@email.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
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
                // Acción para cerrar sesión
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
      leading: Icon(icon, color: Colors.green),
      title: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
