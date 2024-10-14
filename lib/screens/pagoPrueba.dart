import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../componets/CustomButtom.dart';
import '../servicios/paymentServices.dart';

class PruebaPago extends StatefulWidget {
   final Function onPaymentSuccess;  // Callback cuando el pago sea exitoso
  const PruebaPago({super.key, required this.onPaymentSuccess});

  @override
  _PruebaPago createState() => _PruebaPago();
}

class _PruebaPago extends State<PruebaPago> {
  final PaymentServices _paymentServices = PaymentServices();

  Future<void> _makePayment() async {
    try {
      // 1. Crear el PaymentIntent en tu backend
      String clientSecret =
          await _paymentServices.createPaymentIntent(5000, 'usd');

      // 2. Presentar la hoja de pago
      await _paymentServices.presentPaymentSheet(clientSecret);

      // 3. Llamar al callback después del pago exitoso
      widget.onPaymentSuccess();
      // 4. Mostrar un mensaje de éxito
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Pago realizado con éxito"),
        ),
      );
    } catch (e) {
      print(e.toString());

      if (e is StripeException) {
        if (e.error.code == FailureCode.Canceled) {
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              content: Text("El pago fue cancelado por el usuario."),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Text("Error en el pago: ${e.error.localizedMessage}"),
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text("Error en el pago: $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Center(
              child: CustomButton(
                textColor: Colors.white,
                backgroundColor: Colors.black,
                text: 'Pagar',
                onPressed: _makePayment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
