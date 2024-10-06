import 'package:OptiVision/providers/proveedor_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../componets/BottonChange.dart';
import '../../componets/ContainerIcon.dart';
import '../../componets/TextFormFieldTheme.dart';
import '../../componets/WabeClipper.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _cambiarEmail() {
    print(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    _emailController.text = userProvider.email ?? '';
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
                'Cambiar correo electrónico',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Ingresa un nuevo correo electrónico',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _emailController,
                  decoration: TextFormFieldTheme.customInputDecoration(
                      labelText: 'Correo Electronico',
                      icon: Icons.email,
                      context: context),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(height: 30),
              BottonChange(
                colorBack: Colors.black,
                colorFont: Colors.white,
                textTile: 'Enviar codigo de validacion',
                onPressed: _cambiarEmail,
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
