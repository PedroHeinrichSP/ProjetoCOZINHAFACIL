import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _passwordController = TextEditingController();
  }

  void _changePassword() async {
    try {
      await _user?.updatePassword(_passwordController.text);
      _showSnackBar('Senha alterada com sucesso.');
    } catch (error) {
      // Trate os erros aqui, por exemplo, exiba uma mensagem de erro
      _showSnackBar('Erro ao alterar a senha: $error');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showUserId() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ID Único do Usuário'),
          content: Text('ID: ${_user?.uid ?? 'N/A'}'),
          actions: <Widget>[
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.brown[200], // Cor de fundo da AppBar (marrom claro)
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Volta para a tela anterior
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20.0), // Adicionado espaçamento
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 100.0,
                  color: Colors.brown[200], // Cor do ícone (marrom claro)
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.brown[200]), // Ícone personalizado (marrom claro)
                    SizedBox(width: 8.0),
                    Text(
                      'ID Único:',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _showUserId,
                  child: Icon(Icons.info, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown[200], // Cor do botão (marrom claro)
                    shape: CircleBorder(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Nova Senha',
                icon: Icon(Icons.lock, color: Colors.brown[200]), // Ícone personalizado (marrom claro)
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Alterar Senha'),
              style: ElevatedButton.styleFrom(
                primary: Colors.brown[200], // Cor do botão (marrom claro)
                textStyle: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(height: 20.0), // Adicionado espaçamento
          ],
        ),
      ),
    );
  }
}
