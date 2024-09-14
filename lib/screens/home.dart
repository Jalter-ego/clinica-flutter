import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const storage = FlutterSecureStorage();
  String? _nombre;

  @override
  void initState() {
    super.initState();
    _cargarNombre();
  }

  Future<void> _cargarNombre() async {
    final nombre = await storage.read(key: 'nombre');
    setState(() {
      _nombre = nombre;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_nombre == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Optivisión'),
          backgroundColor: const Color(0xFF3E69FE), // Color principal de la app
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final bienvenidaText = 'Bienvenido, ${_nombre ?? 'Usuario'}';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Optivisión'),
        backgroundColor: const Color(0xFF3E69FE), // Color principal de la app
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bienvenidaText,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Accesos rápidos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickAction(
                  context,
                  icon: Icons.event_available,
                  label: 'Agendar Cita',
                  route: '/agendar_cita',
                ),
                _buildQuickAction(
                  context,
                  icon: Icons.history,
                  label: 'Historial',
                  route: '/historial',
                ),
                _buildQuickAction(
                  context,
                  icon: Icons.remove_red_eye,
                  label: 'Exámenes',
                  route: '/examenes',
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Información de salud visual
            const Text(
              'Cuida tu salud visual:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '• Realiza una revisión oftalmológica al menos una vez al año.\n'
              '• Usa lentes de sol para proteger tus ojos del sol.\n'
              '• Sigue una dieta rica en vitaminas A, C y E.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Noticias
            const Text(
              'Noticias Oftalmológicas:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.newspaper),
                title: const Text('Nuevas técnicas para tratar el glaucoma'),
                onTap: () {
                  // Acción al tocar la noticia
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.newspaper),
                title: const Text(
                    'Cuidados postoperatorios tras una cirugía ocular'),
                onTap: () {
                  // Acción al tocar la noticia
                },
              ),
            ),
            const SizedBox(height: 20),
            // Contacto
            const Text(
              'Contacto:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Llamar a la clínica'),
              onTap: () {
                // Acción para hacer la llamada
              },
            ),
          ],
        ),
      ),
    );
  }

  void obtenerNombreUsuario() async {}
}

// Widget para crear accesos rápidos
Widget _buildQuickAction(BuildContext context,
    {required IconData icon, required String label, required String route}) {
  return Column(
    children: [
      IconButton(
        icon: Icon(icon, size: 40),
        color: const Color(0xFF3E69FE),
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
      ),
      Text(label),
    ],
  );
}
