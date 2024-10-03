import 'package:flutter/material.dart';

import '../utils/assets.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
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
            _listTile("Inicio", Icons.home, context, '/home'),
            _listTile('Historial', Icons.description, context, '/historial'),
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
                // Puedes añadir más ListTile aquí si es necesario
              ],
            ),
            _listTile(
                'Configuración', Icons.settings, context, '/configuracion'),
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


/*ExpansionTile(
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
                _listTile('Tipos de Contratos', Icons.subdirectory_arrow_right,
                    context, '/home'),
                _listTile('Registro de Profesionales',
                    Icons.subdirectory_arrow_right, context, '/home'),
                _listTile('Profesionales de Salud',
                    Icons.subdirectory_arrow_right, context, '/home'),
              ],
            ),

            ExpansionTile(
              title: const Text(
                'Registros',
                style: TextStyle(fontSize: 14),
              ),
              leading: const Icon(Icons.list),
              children: <Widget>[
                _listTile('Tipos de Atenciones', Icons.subdirectory_arrow_right,
                    context, '/home'),
                _listTile('Departamentos', Icons.subdirectory_arrow_right,
                    context, '/home'),
                _listTile('Especialidades', Icons.subdirectory_arrow_right,
                    context, '/home'),
                _listTile('Servicios', Icons.subdirectory_arrow_right, context,
                    '/home'),
              ],
            ),
            ExpansionTile(
              title: const Text(
                'Administrador',
                style: TextStyle(fontSize: 14),
              ),
              leading: const Icon(Icons.admin_panel_settings),
              children: <Widget>[
                _listTile('Carreras Profesionales',
                    Icons.subdirectory_arrow_right, context, '/home'),
                _listTile('Funciones de Empleados',
                    Icons.subdirectory_arrow_right, context, '/home'),
                _listTile('Programacion de Medicos',
                    Icons.subdirectory_arrow_right, context, '/home'),
              ],
            ),
*/
