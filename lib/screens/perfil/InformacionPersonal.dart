import 'package:OptiVision/componets/ContainerIcon.dart';
import 'package:OptiVision/providers/proveedor_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../componets/WabeClipper.dart';
import '../../providers/theme_Provider.dart';
import 'ChangeEmail.dart';
import 'ChangeName.dart';
import 'ChangePasword.dart';

class InfoPersonal extends StatelessWidget {
  const InfoPersonal({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    var isDark = themeProvider.isDarkMode;
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              ItemUser(
                nombreTile: 'Nombre',
                dataTile: userProvider.nombre ?? 'Nombre de Usuario',
                isEditable: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ChangeName()),
                  );
                },
              ),
              ItemUser(
                nombreTile: 'Apellido Paterno',
                dataTile:
                    userProvider.apellido_paterno ?? 'Apellido de Usuario',
                isEditable: false,
              ),
              Divider(
                color: isDark ? Colors.white30 : Colors.black38,
                height: 0,
              ),
              ItemUser(
                nombreTile: 'Email',
                dataTile: userProvider.email ?? 'Email del Usuario',
                isEditable: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const ChangeEmail()),
                  );
                },
              ),
              Divider(
                color: isDark ? Colors.white30 : Colors.black38,
                height: 0,
              ),
              ItemUser(
                nombreTile: 'Teléfono',
                dataTile: userProvider.telefono ?? 'Teléfono del Usuario',
                isEditable: false,
              ),
              Divider(
                color: isDark ? Colors.white30 : Colors.black38,
                height: 0,
              ),
              ItemUser(
                nombreTile: 'Contraseña',
                dataTile: '********',
                isEditable: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const ChangePassword()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemUser extends StatelessWidget {
  final String nombreTile;
  final String dataTile;
  final bool isEditable;
  final VoidCallback? onTap;

  const ItemUser({
    super.key,
    required this.nombreTile,
    required this.dataTile,
    this.isEditable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nombreTile,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                dataTile,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          if (isEditable) ...[
            GestureDetector(
              onTap: onTap,
              child: const Text(
                'cambiar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
