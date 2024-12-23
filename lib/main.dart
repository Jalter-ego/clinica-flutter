import 'package:OptiVision/screens/Registers/AntecedentesUsuario.dart';
import 'package:OptiVision/servicios/notificationServices.dart';
import 'package:OptiVision/utils/constantes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'providers/proveedor_usuario.dart';
import 'providers/theme_Provider.dart';
import 'screens/login.dart';
import 'screens/splash.dart';
import 'screens/navegador.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  mostrarNotificacion(
      titulo: 'Bienvenido a Optivision',
      cuerpo: 'no se olvide revisar sus recetas medicas, tratamientos....');
  Stripe.publishableKey = Constantes.publicKey;
  Stripe.merchantIdentifier = Constantes.merchantIdentifier;

  await initializeDateFormatting('es_ES', null);
  await Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            getPages: [
              GetPage(name: '/', page: () => const SplashScreen()),
              GetPage(name: '/login', page: () => const LoginPage()),
              GetPage(name: '/home', page: () => const Nav_Rutas()),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('es', ''),
            ],
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
