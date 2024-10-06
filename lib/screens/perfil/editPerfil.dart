import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../componets/TextFormFieldTheme.dart';
import '../../providers/proveedor_usuario.dart';

class UpdatePerfil extends StatelessWidget {
  const UpdatePerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/usuarioLogo.png'),
              ),
              const SizedBox(height: 10),
              // Información personal
              Text(
                userProvider.nombre ?? 'Usuario',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                userProvider.email ?? 'Correo',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: TextFormFieldTheme.customInputDecoration(
                            labelText: 'Nombre',
                            icon: Icons.person,
                            context: context),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: TextFormFieldTheme.customInputDecoration(
                            labelText: 'Email',
                            icon: Icons.email,
                            context: context),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: TextFormFieldTheme.customInputDecoration(
                            labelText: 'Teléfono',
                            icon: Icons.phone,
                            context: context),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: TextFormFieldTheme.customInputDecoration(
                            labelText: 'Contraseña',
                            icon: Icons.lock,
                            context: context),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
