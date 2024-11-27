import 'package:OptiVision/componets/HomeCardService.dart';
import 'package:OptiVision/screens/Registers/HistorialPage.dart';
import 'package:OptiVision/screens/recetasMedicas.dart';
import 'package:OptiVision/screens/tratamientos.dart';
import 'package:OptiVision/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../componets/FadePage.dart';
import '../providers/proveedor_usuario.dart';
import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
    final saludo = obtenerSaludo();
    final bienvenidaText = '$saludo ${userProvider.nombre ?? 'Usuario'}';

    return Scaffold(
      appBar: AppBar(
          title:
              const Text('Optivisión', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF0057E5),
          iconTheme: const IconThemeData(
            color: Colors.white,
          )),
      drawer: userProvider.rol != 'cliente' ? const AppDrawer() : null,
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 250),
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
                      page: const SplashScreen(),
                    ),
                    _buildQuickAction(
                      context,
                      icon: Icons.history,
                      label: 'Historial',
                      page: const HistorialPage(),
                    ),
                    _buildQuickAction(
                      context,
                      icon: Icons.remove_red_eye,
                      label: 'Exámenes',
                      page: const SplashScreen(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Contacto:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Llamar a la clínica',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Acción para hacer la llamada
                  },
                ),
                // Sección de servicios
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Nuestros Servicios:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    HomeCardService(
                      width: 320,
                      height: 90,
                      icon1: LineAwesomeIcons.user_md_solid,
                      text1: 'Consulta Médica',
                      text2: 'Agende su consulta general',
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    HomeCardService(
                      width: 320,
                      height: 90,
                      icon1: LineAwesomeIcons.capsules_solid,
                      text1: 'Recetas Medicas',
                      text2: 'Encuentre sus recetas medicas',
                      onTap: () {
                        Navigator.of(context).push(
                          FadeThroughPageRoute(
                            page: const RecetasMedicasPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    HomeCardService(
                      width: 320,
                      height: 90,
                      icon1: LineAwesomeIcons.vial_solid,
                      text1: 'Tratamientos',
                      text2: 'Encuentre sus tratamientos',
                      onTap: () {
                        Navigator.of(context).push(
                          FadeThroughPageRoute(
                            page: const TratamientosPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildQuickAction(BuildContext context,
    {required IconData icon, required String label, required Widget page}) {
  return Column(
    children: [
      IconButton(
        icon: Icon(icon, size: 40),
        color: const Color.fromARGB(255, 255, 255, 255),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
      Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    ],
  );
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0057E5)
      ..style = PaintingStyle.fill;

    final rRect = RRect.fromLTRBAndCorners(
      0, // Izquierda
      0, // Arriba
      size.width, // Derecha
      size.height, // Abajo
      topLeft: Radius.zero, // Esquinas superiores rectas
      topRight: Radius.zero, // Esquinas superiores rectas
      bottomLeft:
          const Radius.circular(30.0), // Esquina inferior izquierda redondeada
      bottomRight:
          const Radius.circular(30.0), // Esquina inferior derecha redondeada
    );

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
