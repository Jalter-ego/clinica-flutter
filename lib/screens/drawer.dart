import 'package:OptiVision/screens/Registers/AntecedentesPage.dart';
import 'package:OptiVision/screens/Registers/ProgramingMedicals.dart';
import 'package:OptiVision/screens/Registers/Triaje.dart';

import 'Registers/Services.dart';
import 'Registers/Citas.dart';
import 'Registers/Specialties.dart';
import 'package:flutter/material.dart';
import '../componets/WabeClipper.dart';
import '../utils/assets.dart';
import 'Registers/Departments.dart';

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
                _listTile(
                  'Registro de Departamentos',
                  Icons.apartment_outlined,
                  context,
                  const Departaments(),
                ),
                _listTile(
                  'Registro de Especialidades',
                  Icons.medical_services,
                  context,
                  const Specialties(),
                ),
                _listTile(
                  'Registro de Servicios',
                  Icons.medical_services_outlined,
                  context,
                  const Services(),
                ),
                _listTile(
                  'Programacion de Medicos',
                  Icons.medical_services_outlined,
                  context,
                  const ProgramingMedicals(),
                ),
                _listTile(
                  'Registro de Citas',
                  Icons.note_alt_outlined,
                  context,
                  const Citas(),
                ),
                _listTile(
                  'Gestion de Triaje',
                  Icons.my_library_books_sharp,
                  context,
                  const GestionarTriaje(),
                ),
                _listTile(
                  'Antecedentes',
                  Icons.attribution_outlined,
                  context,
                  const AntecedentesScreen(),
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
