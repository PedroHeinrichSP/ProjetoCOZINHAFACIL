import 'package:flutter/material.dart';
import 'package:cozinhafacil/utils/pallete.dart';
import 'DatabaseHelper.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  bool _showPassword = false; // Variável para controlar a visibilidade da senha
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Usar a CustomAppBar personalizada
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Olá,\nBem vindo!',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Alinha o texto ao centro
              ),
              SizedBox(height: 35.0),
              TextField(
              controller: usernameController, // Bind the username controller
              decoration: InputDecoration(
                labelText: 'Nome de Usuário',
              ),
            ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: !_showPassword, // Oculta a senha com base no valor de _showPassword
                decoration: InputDecoration(
                  labelText: 'Senha',
                  // Adiciona o ícone de "olho" para mostrar/ocultar a senha
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword; // Alterna a visibilidade da senha
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                obscureText: !_showPassword, // Oculta a senha com base no valor de _showPassword
                decoration: InputDecoration(
                  labelText: 'Confirme a Senha',
                  // Adiciona o ícone de "olho" para mostrar/ocultar a senha
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword; // Alterna a visibilidade da senha
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 32.0),
               ElevatedButton(
              onPressed: () async {
                String username = usernameController.text;
                String password = passwordController.text;

                // Simple validation
               if (username.isNotEmpty && password.isNotEmpty) {
                Map<String, dynamic> newUser = {
                    DatabaseHelper.columnUserName: username,
                    DatabaseHelper.columnPassword: password
                };
                int? id = await DatabaseHelper.instance.insert(newUser);
                if (id != null && id > 0) {
                    print("deu bom");
                } else {
                    print("deu ruim");
                }
                } else {
                    // Show a dialog or snackbar saying fields are empty
                    print("Campos vazios!");
                    return;
                }


                // Creating a row to insert
                Map<String, dynamic> row = {
                  DatabaseHelper.columnUserName : username,
                  DatabaseHelper.columnPassword : password
                };

                final dbHelper = DatabaseHelper.instance;

                // Insert the row and handle potential errors
                try {
                  final id = await dbHelper.insert(row);
                  print('Usuário cadastrado com id: $id');
                  // Navigate to another screen or show dialog saying 'User registered'
                } catch (e) {
                  print('Error: $e');
                  // Show dialog or snackbar with error message
                }
              },
              child: Text('Cadastrar'),
            ),

            ],
          ),
        ),
      ),
    );
  }

}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56.0); // Altura da AppBar

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      iconTheme: IconThemeData(
        color: AppColors.textColor, // Define a cor do ícone (seta de voltar)
      ),
      title: const Text(
        'Tela de Cadastro',
        style: TextStyle(
          color: AppColors.textColor, // Define a cor do texto da AppBar como preto
        ),
      ),
    );
  }
}
