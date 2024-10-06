import 'package:flutter/material.dart';
import 'drawer.dart';
import 'home.dart';
import 'horarios.dart';
import 'informacio.dart';
import 'perfil/perfil.dart';

class Nav_Rutas extends StatefulWidget {
  const Nav_Rutas({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Nav_Rutas_State createState() => _Nav_Rutas_State();
}

class _Nav_Rutas_State extends State<Nav_Rutas> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    const HorariosScreen(),
    const InformacionScreen(),
    const PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomNavigationBar(
          elevation: 5,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF0057E5),
          unselectedItemColor: Colors.black54,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: "Horarios",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_information),
              label: "Informacion",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity),
              label: "Perfil",
            ),
          ],
        ),
      ),
    );
  }
}
