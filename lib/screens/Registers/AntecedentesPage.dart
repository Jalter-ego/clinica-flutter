import 'package:flutter/material.dart';

import '../../componets/CustomAppBar.dart';

class AntecedentesPage extends StatelessWidget {
  final List<Map<String, String>> antecedentes = [
    {
      'titulo': 'Hipertensión',
      'detalles': 'Diagnóstico hace 5 años. Tratamiento actual con Enalapril.',
    },
    {
      'titulo': 'Diabetes tipo 2',
      'detalles': 'Diagnóstico hace 2 años. Controlada con Metformina.',
    },
    {
      'titulo': 'Alergia a penicilina',
      'detalles': 'Reacción alérgica severa registrada en 2018.',
    },
  ];

  void _mostrarDetalles(BuildContext context, String titulo, String detalles) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(detalles),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Registro de',
        title2: 'Antecedentes',
        icon: Icons.arrow_back_ios_rounded,
        onIconPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: antecedentes.length,
          itemBuilder: (BuildContext context, int index) {
            final antecedente = antecedentes[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(antecedente['titulo']!),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                onTap: () {
                  _mostrarDetalles(
                    context,
                    antecedente['titulo']!,
                    antecedente['detalles']!,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
