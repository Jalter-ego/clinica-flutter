import 'package:OptiVision/providers/proveedor_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../componets/CustomButtom.dart';
import '../servicios/autenticacion_Services.dart';

class RatingModal extends StatefulWidget {
  const RatingModal({super.key});

  @override
  RatingModalState createState() => RatingModalState();
}

class RatingModalState extends State<RatingModal> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  final AutenticacionServices _authService = AutenticacionServices();
  int userId = 1;
  String username = "UsuarioEjemplo";

  Future<void> _submitComment() async {
    final comment = _commentController.text;
    final rating = _rating.toInt();

    if (comment.isEmpty || rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Por favor, ingrese un comentario y una calificación.')),
      );
      return;
    }

    try {
      await _authService.createComentario(comment, rating, username, userId);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Gracias por tu comentario!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar el comentario.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    username = userProvider.nombre!;
    userId = userProvider.id!;

    return AlertDialog(
      title: const Text(
        'Déjanos tu opinión',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Qué te ha parecido la experiencia?'),
            const SizedBox(height: 16),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Escribe tu comentario',
                labelStyle: const TextStyle(color: Colors.black38),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            child: CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              textColor: Colors.white,
              backgroundColor: Colors.blue,
              text: 'Cancelar',
            ),
          ),
          SizedBox(
            child: CustomButton(
              onPressed: _submitComment,
              textColor: Colors.white,
              backgroundColor: Colors.green,
              text: '  Enviar  ',
            ),
          ),
        ])
      ],
    );
  }
}
