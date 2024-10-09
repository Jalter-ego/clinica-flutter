import 'package:flutter/material.dart';
import '../componets/WabeClipper.dart';
import '../utils/assets.dart';
import 'Registers/Departaments.dart';
import 'home.dart';

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
                const SizedBox(height: 40),
                _listTile("Inicio", Icons.home, context, const HomeScreen()),
                ExpansionTile(
                  title: const Text(
                    'Registros',
                    style: TextStyle(fontSize: 14),
                  ),
                  leading: const Icon(Icons.app_registration),
                  children: <Widget>[
                    _listTile(
                      'Registro de Departamentos',
                      Icons.subdirectory_arrow_right,
                      context,
                      const Departaments(),
                    ),
                  ],
                ),
              ],
            ),
            // Ondulación superpuesta
            Positioned(
              top: 150,
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

  Widget _listTile(String title, IconData icon, BuildContext context,
      Widget destinationScreen) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      leading: Icon(icon),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
    );
  }
}
