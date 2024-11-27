import 'package:OptiVision/screens/perfil/NewPassword.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../componets/BottonChange.dart';
import '../../componets/ContainerIcon.dart';
import '../../componets/Loading.dart';
import '../../componets/TextFormFieldTheme.dart';
import '../../componets/WabeClipper.dart';
import '../../providers/proveedor_usuario.dart';
import '../../servicios/autenticacion_Services.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _cambiarContrasena() async {
    String password = _passwordController.text;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String ci = userProvider.ci ?? '';

    // Mostrar pantalla de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingScreen();
      },
    );

    final result = await AutenticacionServices().verifyPassword(
      context: context,
      ci: ci,
      password: password,
    );

    // Cerrar el diálogo de carga
    Navigator.of(context).pop(); // Cierra el LoadingScreen

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña Verificada!')),
      );

      // Navegar a NewPassword después de cerrar el diálogo
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const NewPassword()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: double.infinity,
            color: const Color(0xFF0057E5),
          ),
        ),
        toolbarHeight: 110,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const ContainerIcon(
                icon: Icons.arrow_back_ios_rounded,
                iconColor: Colors.white,
                containerColor: Colors.white10,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 8),
            const ContainerIcon(
              icon: Icons.person,
              iconColor: Colors.white,
              containerColor: Colors.white10,
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Información',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'personal',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Cambiar contraseña',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 0,
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Para cambiar tu contraseña debes ingresar la que usas actualmente',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _passwordController,
                  decoration: TextFormFieldTheme.customInputDecoration(
                      labelText: 'Actual contraseña',
                      icon: Icons.lock,
                      context: context),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(height: 30),
              BottonChange(
                colorBack: Colors.black,
                colorFont: Colors.white,
                textTile: 'Cambiar contraseña',
                onPressed: _cambiarContrasena,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
