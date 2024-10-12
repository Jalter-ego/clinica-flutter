
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'providers/proveedor_usuario.dart';
import 'providers/theme_Provider.dart';
import 'screens/login.dart';
import 'screens/splash.dart';
import 'screens/navegador.dart';
import 'screens/registro_de_empleados.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return GetMaterialApp(
            title: 'Namer App',
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(137, 90, 135, 218),
              ),
              textTheme: GoogleFonts.nunitoTextTheme(),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF121212),
                brightness: Brightness.dark,
              ),
              textTheme: GoogleFonts.nunitoTextTheme(
                ThemeData(brightness: Brightness.dark).textTheme,
              ),
            ),
            themeMode: themeProvider.themeMode, // Escucha el tema activo
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => const SplashScreen()),
              GetPage(name: '/login', page: () => const LoginPage()),
              GetPage(name: '/home', page: () => const Nav_Rutas()),
              GetPage(
                name: '/registro_empleados',
                page: () => const EmployeeRegistrationPage(),
              ),
            ],
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
