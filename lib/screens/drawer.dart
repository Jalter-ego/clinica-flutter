import 'package:flutter/material.dart';

class User {
  final String name;
  final String role;

  User({required this.name, required this.role});
}

// Ejemplo de un usuario con rol de doctor
User currentUser = User(name: 'Dr. House', role: 'Doctor');

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
                backgroundImage: AssetImage('lib/screens/usuarioLogo.png'),
              ),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            _listTile("home", Icons.home, context, '/home'),
            _listTile('Historial', Icons.description, context, '/home'),
            _listTile('Reservar Citas', Icons.calendar_today, context, '/home'),
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
            _listTile('Configuración', Icons.settings, context, '/home'),
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
        Navigator.pushNamed(
            context, routeName); // Navega a la ruta especificada
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
