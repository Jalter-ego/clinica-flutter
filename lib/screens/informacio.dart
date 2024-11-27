import 'package:flutter/material.dart';
import '../componets/CustomAppBar.dart';
import '../servicios/patologiasServices.dart';

class InformacionScreen extends StatefulWidget {
  const InformacionScreen({super.key});

  @override
  _InformacionScreenState createState() => _InformacionScreenState();
}

class _InformacionScreenState extends State<InformacionScreen> {
  late Future<List<Map<String, dynamic>>> _patologiasFuture;

  @override
  void initState() {
    super.initState();
    _patologiasFuture = PatologiasServices().getPatologias(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
        title1: 'Informacion',
        title2: 'Sobre Patologias',
        icon: Icons.medical_information,
        onIconPressed: () {
        },
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( 
        future: _patologiasFuture, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay patologías disponibles.'));
          } else {
            List<Map<String, dynamic>> patologias = snapshot.data!;

            return ListView.builder(
              itemCount: patologias.length,
              itemBuilder: (context, index) {
                final patologia = patologias[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        
                         Text(
                          patologia['nombre'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10), 
                        Image.network(
                          patologia['imagen'],
                          width: 150, 
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            patologia['descripcion'],
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
