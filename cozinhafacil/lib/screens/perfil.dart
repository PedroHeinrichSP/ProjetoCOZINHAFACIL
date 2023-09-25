import 'package:flutter/material.dart';
import 'package:cozinhafacil/utils/pallete.dart';

void main() => runApp(MaterialApp(
      home: PerfilScreen(),
    ));

class PerfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(
          color: AppColors.textColor,
        ),
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: AppColors.textColor,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.buttonPrimaryColor, // Altere para verde
              ),
              child: Icon(
                Icons.person,
                size: 100,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nome do Usuário',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'nome.usuario@email.com',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Telefone'),
              subtitle: Text('+55 11 1234-5678'),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Endereço'),
              subtitle: Text('Rua da Amostra, 123'),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Implemente a lógica de saída da conta aqui
                // Por exemplo, você pode fazer logout do usuário
                // e redirecioná-lo para a tela de login.
                Navigator.of(context).pop(); // Fecha a tela de perfil
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Sair da Conta',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
