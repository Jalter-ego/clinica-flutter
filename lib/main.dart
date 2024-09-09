import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'providers/proveedor_usuario.dart';
import 'screens/login.dart';
import 'screens/splash.dart'; // Asegúrate de que el archivo es correcto
import 'screens/home_page.dart';
import 'screens/registro_de_empleados.dart';

void main() {
  Get.put(UserProvider());
  runApp(
    GetMaterialApp(
      title: 'Namer App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(137, 90, 135, 218),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/home', page: () => const MyHomePage()),
        GetPage(
            name: '/registro_empleados',
            page: () => const EmployeeRegistrationPage()),
      ],
      debugShowCheckedModeBanner: false,
    ),
  );
}
