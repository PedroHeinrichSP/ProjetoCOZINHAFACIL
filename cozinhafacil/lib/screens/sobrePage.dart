import 'package:flutter/material.dart';
import 'package:cozinhafacil/utils/pallete.dart';

class SobrePage extends StatefulWidget {
  @override
  SobrePageState createState() => SobrePageState();
}

class SobrePageState extends State<SobrePage> {
  @override
  Widget build(BuildContext context) {
    // Constants
    const double imageSize = 350.0;
    const double verticalSpacing = 20.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[200], // Cor marrom claro
        iconTheme: const IconThemeData(
          color: AppColors.textColor,
        ),
        title: const Text(
          'Sobre',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/puc_minas_logo.png',
                width: imageSize,
                height: imageSize,
              ),
              const SizedBox(height: verticalSpacing),
              Text(
                'Cozinha Fácil',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: verticalSpacing),
              Text(
                'Este é um aplicativo de culinária fácil que ajuda você a encontrar e compartilhar receitas deliciosas.',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: verticalSpacing),
              Text(
                'Versão: 1.0.0',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
