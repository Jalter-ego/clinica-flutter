import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_frontend/utils/assets.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () => Get.offAllNamed('/login'),
    );

    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: Center(
        child: Image.asset(
          Assets.imagesAppFondo,
          scale: 2.5,
        ),
      ),
    );
  }
}
