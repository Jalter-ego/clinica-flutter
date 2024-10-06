import 'package:OptiVision/componets/BottonCancel.dart';
import 'package:OptiVision/providers/proveedor_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../componets/BottonChange.dart';
import '../../componets/ContainerIcon.dart';
import '../../componets/Loading.dart';
import '../../componets/TextFormFieldTheme.dart';
import '../../componets/WabeClipper.dart';
import '../../servicios/autenticacion_Services.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({super.key});

  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoPaternoController =
      TextEditingController();
  final TextEditingController _apellidoMaternoController =
      TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoPaternoController.dispose();
    _apellidoMaternoController.dispose();
    super.dispose();
  }

  void _guardarCambios() async {
    String nombre = _nombreController.text;
    String apellidoPaterno = _apellidoPaternoController.text;
    String apellidoMaterno = _apellidoMaternoController.text;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String ci = userProvider.ci ?? '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingScreen();
      },
    );
    final result = await AutenticacionServices().updateUserName(
      context: context,
      ci: ci,
      nombre: nombre,
      apellidoPaterno: apellidoPaterno,
      apellidoMaterno: apellidoMaterno,
    );

    Navigator.of(context).pop();

    if (result != null) {
      userProvider.nombre = nombre;
      userProvider.apellido_paterno = apellidoPaterno;
      userProvider.apellido_materno = apellidoMaterno;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cambios guardados exitosamente!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    _nombreController.text = userProvider.nombre ?? '';
    _apellidoPaternoController.text = userProvider.apellido_paterno ?? '';
    _apellidoMaternoController.text = userProvider.apellido_materno ?? '';
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
              const SizedBox(height: 25),
              const Text(
                'Cambiar nombre y/o apellido',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _nombreController,
                  decoration: TextFormFieldTheme.customInputDecoration(
                    labelText: 'Nombre',
                    icon: Icons.person,
                    context: context,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _apellidoPaternoController,
                  decoration: TextFormFieldTheme.customInputDecoration(
                    labelText: 'Apellido Paterno',
                    icon: Icons.person,
                    context: context,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _apellidoMaternoController,
                  decoration: TextFormFieldTheme.customInputDecoration(
                    labelText: 'Apellido Materno',
                    icon: Icons.person,
                    context: context,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              BottonChange(
                colorBack: Colors.black,
                colorFont: Colors.white,
                textTile: 'Guardar Cambios',
                onPressed: _guardarCambios,
              ),
              const SizedBox(height: 20),
              const BottonCancel(
                colorFont: Colors.black,
                textTile: 'Cancelar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
