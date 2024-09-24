import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_frontend/servicios/autenticacion_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'navegador.dart';
import 'package:flutter_frontend/providers/proveedor_usuario.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AutenticacionServices authService = AutenticacionServices();

  late final AnimationController _fadeAnimationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeIn,
    );

    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    super.dispose();
  }

  void _login() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ci = _usernameController.text;
    final password = _passwordController.text;

    try {
      final response = await authService.loginUsuario(
        context: context,
        ci: ci,
        password: password,
      );

      if (response != null) {
        final token = response['token'];
        const storage = FlutterSecureStorage();
        await storage.write(key: 'token', value: token);

        // Obtén el nombre del usuario
        final String? usuario = await authService.obtenerUsuario();
        // Guarda el nombre en el almacenamiento seguro
        await storage.write(key: 'nombre', value: usuario);
        //actualiza el estado
        userProvider.setUser({'token': token, 'nombre': usuario});

        // Navega a la página de inicio
        Get.offAll(() => const Nav_Rutas());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña incorrectos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Center(
          child: Transform.translate(
            offset: const Offset(0, -40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Seguridad',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.login,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  const Text(
                    'Inicio de sesión',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildTextField(
                          'Usuario', 'Usuario', _usernameController, false),
                      const SizedBox(height: 12),
                      buildTextField('Contraseña', 'Contraseña',
                          _passwordController, true),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 13, 187, 167),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_open,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            SizedBox(width: 2),
                            Text('Login'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildTextField(String label, String hint,
    TextEditingController controller, bool isPassword) {
  return SizedBox(
    width: 200,
    height: 40,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 174, 191, 200)),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 174, 191, 200)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      ),
      obscureText: isPassword,
    ),
  );
}
