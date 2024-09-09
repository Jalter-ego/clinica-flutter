import 'package:flutter/material.dart';
import 'drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   int _selectedIndex = 0;

  // Lista de widgets para cada página de la barra de navegación
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Inicio')),
    Center(child: Text('Horarios')),
    Center(child: Text('Información')),
    Center(child: Text('Perfil')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
      ),
      drawer: const AppDrawer(),
      body: _pages[_selectedIndex], // Cambia el contenido según el índice seleccionado
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Horarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Información',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue, // Cambia el color del icono seleccionado
        unselectedItemColor: Colors.lightBlue, // Color de los íconos no seleccionados
        onTap: _onItemTapped,
      ),
    );
  }
}

Widget listTile(String title, IconData icono, BuildContext context) {
  return ListTile(
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 14,
      ),
    ),
    leading: Icon(icono),
    onTap: () {
      Navigator.pop(context);
    },
  );
}
