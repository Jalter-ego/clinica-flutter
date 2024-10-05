import 'package:flutter/material.dart';
import '../componets/WabeClipper.dart';
import '../utils/assets.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const UserAccountsDrawerHeader(
                  accountName: Text('Administrador de Sistema'),
                  accountEmail: Text('@misadev'),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage(Assets.imagesAppUserLogo),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF0057E5),
                  ),
                ),
                // Aquí insertamos la ondulación con `Stack` para que se superponga
                SizedBox(height: 40), // Espacio para que el contenido baje
                _listTile("Inicio", Icons.home, context, '/home'),
                _listTile(
                    'Historial', Icons.description, context, '/historial'),
                _listTile('Reservar Citas', Icons.calendar_today, context,
                    '/reservar_citas'),
                ExpansionTile(
                  title: const Text(
                    'Personal',
                    style: TextStyle(fontSize: 14),
                  ),
                  leading: const Icon(Icons.person),
                  children: <Widget>[
                    _listTile(
                        'Registro de Empleados',
                        Icons.subdirectory_arrow_right,
                        context,
                        '/registro_empleados'),
                  ],
                ),
                _listTile(
                    'Configuración', Icons.settings, context, '/configuracion'),
              ],
            ),
            // Ondulación superpuesta
            Positioned(
              top:
                  150, // Ajusta para superponer sobre el `UserAccountsDrawerHeader`
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  color: const Color(0xFF0057E5),
                  height: 50.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listTile(
      String title, IconData icon, BuildContext context, String routeName) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      leading: Icon(icon),
      onTap: () {
        Navigator.pop(context); // Cierra el Drawer
        Navigator.pushReplacementNamed(context,
            routeName); // Reemplaza la ruta actual en lugar de apilarla
      },
    );
  }
}
