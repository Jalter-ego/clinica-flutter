import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/proveedor_usuario.dart';
import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Función para obtener el saludo dependiendo de la hora
  String obtenerSaludo() {
    final horaActual = DateTime.now().hour;
    if (horaActual >= 6 && horaActual < 12) {
      return 'Buenos días';
    } else if (horaActual >= 12 && horaActual < 18) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final saludo = obtenerSaludo(); // Obtener el saludo basado en la hora
    final bienvenidaText = '$saludo ${userProvider.nombre ?? 'Usuario'}';

    return Scaffold(
      appBar: AppBar(
          title:
              const Text('Optivisión', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF0057E5),
          iconTheme: const IconThemeData(
            color: Colors.white, // Color de las 3 barras del Drawer
          )),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          // Dibuja el círculo en la mitad superior de la pantalla
          CustomPaint(
            size: Size(
                MediaQuery.of(context).size.width, 250), // Tamaño del círculo
            painter: CirclePainter(),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bienvenidaText,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white)),
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
                const SizedBox(height: 60),
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
        ],
      ),
    );
  }
}

// Widget para crear accesos rápidos
Widget _buildQuickAction(BuildContext context,
    {required IconData icon, required String label, required String route}) {
  return Column(
    children: [
      IconButton(
        icon: Icon(icon, size: 40),
        color: const Color.fromARGB(255, 255, 255, 255),
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
      ),
      Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    ],
  );
}

// Clase que dibuja un círculo en la parte superior de la pantalla
class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0057E5)
      ..style = PaintingStyle.fill;

    // Dibujar un círculo parcial
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, -size.height / 1.3),
          radius: size.height * 1.5),
      0.0, // Ángulo inicial
      3.14, // Ángulo barrido (radianes para medio círculo)
      true, // Si debe pintar desde el centro
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
