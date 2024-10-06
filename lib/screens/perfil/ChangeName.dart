import 'package:OptiVision/componets/BottonCancel.dart';
import 'package:flutter/material.dart';

import '../../componets/BottonChange.dart';
import '../../componets/ContainerIcon.dart';
import '../../componets/TextFormFieldTheme.dart';
import '../../componets/WabeClipper.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

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
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Cambiar nombre y/o apellido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                decoration: TextFormFieldTheme.customInputDecoration(
                    labelText: 'Nombre', icon: Icons.person, context: context),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              child: TextFormField(
                decoration: TextFormFieldTheme.customInputDecoration(
                    labelText: 'Apellido',
                    icon: Icons.person,
                    context: context),
              ),
            ),
            const SizedBox(height: 30),
            const BottonChange(
              colorBack: Colors.black,
              colorFont: Colors.white,
              textTile: 'Guardar Cambios',
            ),
            const SizedBox(
              height: 20,
            ),
            const BottonCancel(
              colorFont: Colors.black,
              textTile: 'Cancelar',
            )
          ],
        ),
      ),
    );
  }
}
