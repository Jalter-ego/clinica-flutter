import 'package:OptiVision/screens/perfil/InformacionPersonal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/proveedor_usuario.dart';
import '../../providers/theme_Provider.dart';
import '../login.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Future<void> _cerrarSesion() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
    await storage.delete(key: 'nombre');

    Get.offAll(() => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    var isDark = themeProvider.isDarkMode;
    print(isDark);
    print(isDark);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil de Usuario',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.toggleTheme(!isDark);
            },
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/usuarioLogo.png'),
              ),
              const SizedBox(height: 10),
              // Información personal
              Text(
                userProvider.nombre ?? 'Usuario',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                userProvider.email ?? 'Correo',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const InfoPersonal()),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0057E5),
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(
                    'Editar Perfil',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Divider(color: isDark ? Colors.white30 : Colors.black38),

              const _ListTile("Configuración", Icons.settings, true),
              const _ListTile("Historial", Icons.history_outlined, true),

              Divider(color: isDark ? Colors.white30 : Colors.black38),

              const _ListTile("Información", Icons.info_outline, true),
              ListTile(
                onTap: _cerrarSesion,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color.fromARGB(255, 196, 205, 209)),
                  child: const Icon(
                    Icons.logout_outlined,
                    color: Colors.black45,
                  ),
                ),
                title: const Text(
                  "Cerrar Sesión",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile(this.title, this.icon, this.isIcon);
  final String title;
  final IconData icon;
  final bool isIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: const Color.fromARGB(255, 196, 205, 209)),
        child: Icon(
          icon,
          color: Colors.black45,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      trailing: isIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(255, 233, 238, 241)),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
