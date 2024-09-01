//lib/main.dart
import 'package:flutter_frontend/providers/proveedor_usuario.dart';
import 'screens/home_page.dart';
import 'screens/login.dart';
import 'package:flutter/material.dart';
import 'screens/Registro_de_empleados.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namer App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(137, 90, 135, 218),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const MyHomePage(),
        '/registro_empleados': (context) => const EmployeeRegistrationPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
