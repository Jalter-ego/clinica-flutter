import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/proveedor_usuario.dart';
import '../utils/assets.dart';
import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    final List<Map<String, String>> servicios = [
      {
        'imagePath': Assets.home1,
        'title': 'Cirugía LASIK',
        'description': 'Corrección visual mediante cirugía láser avanzada.',
      },
      {
        'imagePath': Assets.home2,
        'title': 'Diagnóstico completo',
        'description': 'Exámenes de visión precisos y personalizados para ti.',
      },
      {
        'imagePath': Assets.home3,
        'title': 'Tratamiento de cataratas',
        'description': 'Recupera tu visión con nuestras técnicas quirúrgicas.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
          title:
              const Text('Optivisión', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF0057E5),
          iconTheme: const IconThemeData(
            color: Colors.white,
          )),
      drawer: const AppDrawer(),
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
                const SizedBox(height: 30),
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
                const Text(
                  'Nuestros Servicios:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 340,
                  child: PageView.builder(
                    itemCount: servicios.length,
                    itemBuilder: (context, index) {
                      final servicio = servicios[index];
                      return _buildServiceCard(
                        context,
                        imagePath: servicio['imagePath']!,
                        title: servicio['title']!,
                        description: servicio['description']!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildServiceCard(BuildContext context,
    {required String imagePath,
    required String title,
    required String description}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            height: 220,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            description,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    ),
  );
}

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
