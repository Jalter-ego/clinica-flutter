import 'package:flutter/material.dart';
import 'drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text('Contenido principal'),
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
