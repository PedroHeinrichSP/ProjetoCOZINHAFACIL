import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'user_model.dart';

// Tela de Perfil para exibir e alterar informações do usuário
class PerfilScreen extends StatefulWidget {
  final String username;
  final String password;

  // Construtor da tela de perfil com nome de usuário e senha como parâmetros obrigatórios
  PerfilScreen({required this.username, required this.password});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  TextEditingController _newPasswordController = TextEditingController(); // Controlador para a nova senha
  late String _currentPassword; // Senha atual

  // Inicializa o estado com a senha atual do widget
  @override
  void initState() {
    super.initState();
    _currentPassword = widget.password;
  }

  // Função para atualizar a senha
  void _changePassword() async {
    if (_newPasswordController.text.isEmpty) {
      _showAlertDialog(context, "Por favor, insira a nova senha.");
    } else {
      await DatabaseHelper.instance.updatePassword(widget.username, _newPasswordController.text);
      setState(() {
        _currentPassword = _newPasswordController.text; // Atualiza a senha atual com a nova senha
        _newPasswordController.clear(); // Limpa o controlador da nova senha
      });
    }
  }

  // Função para mostrar a caixa de diálogo
  Future<void> _showAlertDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mudança de Senha'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha a caixa de diálogo
              },
            ),
          ],
        );
      },
    );
  }

  // Constrói a tela do perfil
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Username: ${widget.username}', // Exibe o nome de usuário
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Senha: $_currentPassword', // Exibe a senha atual
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Nova Senha'), // Campo de entrada para a nova senha
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _changePassword(); // Chama a função para atualizar a senha
                },
                child: Text('Trocar Senha'), // Botão para alterar a senha
              ),
            ],
          ),
        ),
      ),
    );
  }
}
