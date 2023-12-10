import 'package:flutter/material.dart';
import 'cadastro.dart';
import 'cadastroReceitas.dart';
import 'perfil.dart' as perfil;
import 'receitasCurtidas.dart'; // Importe a página ReceitasCurtidasPage
import 'package:firebase_auth/firebase_auth.dart';
import 'minhasReceitas.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _userId; // Adiciona esta linha
  bool _isLoggedIn = false;
  late User? _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  void _checkLoginStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _isLoggedIn = true;
        _userId = user.uid; // Adiciona esta linha para armazenar o ID do usuário
      });
    }
  }

  void _login(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      setState(() {
        _isLoggedIn = true;
      });

      _showDialog(context, "Login bem-sucedido. ID: ${userCredential.user!.uid}");
    } catch (error) {
      String errorMessage = _getErrorMessage(error);
      _showDialog(context, errorMessage);
    }
  }

  void _logout(BuildContext context) async {
    await _auth.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  String _getErrorMessage(dynamic error) {
    String errorMessage = 'Ocorreu um erro ao tentar fazer login.';

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          errorMessage = 'E-mail fornecido não é válido.';
          break;
        case 'user-not-found':
          errorMessage = 'Usuário não encontrado. Verifique o e-mail informado.';
          break;
        case 'wrong-password':
          errorMessage = 'Senha incorreta. Verifique sua senha e tente novamente.';
          break;
        case 'user-disabled':
          errorMessage = 'A conta de usuário foi desabilitada. Entre em contato com o suporte.';
          break;
        default:
          errorMessage = 'Erro no login. Verifique sua email/senha e tente novamente. ';
          break;
      }
    }

    return errorMessage;
  }

  void _navigateToCadastro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  void _navigateToPerfil(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => perfil.PerfilScreen()),
    );
  }

  void _navigateToCadastrarReceitas(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeForm(userId: _userId),
      ),
    );
  }

  void _navigateToMinhasReceitas(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyRecipes(),
      ),
    );
  }

  void _navigateToReceitasCurtidas(BuildContext context) {
    if (_isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceitasCurtidasPage(userId: _userId!), // Passa o userId ao criar a instância da página
        ),
      );
    }
  }


  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
        title: Text(_isLoggedIn ? 'Opções' : 'Login'),
        automaticallyImplyLeading: _isLoggedIn ? false : true,
        actions: [
          if (_isLoggedIn)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
        ],
        backgroundColor: Colors.brown[200], // Cor de fundo da barra de navegação
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return _isLoggedIn
        ? _buildLoggedInBody()
        : _buildLoggedOutBody();
  }

  Widget _buildLoggedInBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ElevatedButton(
          onPressed: () => _navigateToPerfil(context),
          style: ElevatedButton.styleFrom(
            primary: Colors.brown[400], // Cor do botão "Perfil"
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.person),
              SizedBox(width: 8.0),
              Text('Perfil'),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () => _navigateToCadastrarReceitas(context),
          style: ElevatedButton.styleFrom(
            primary: Colors.brown[400], // Cor do botão "Cadastrar Receitas"
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.book),
              SizedBox(width: 8.0),
              Text('Cadastrar Receitas'),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () => _navigateToMinhasReceitas(context),
          style: ElevatedButton.styleFrom(
            primary: Colors.brown[400], // Cor do botão "Minhas Receitas"
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.food_bank),
              SizedBox(width: 8.0),
              Text('Minhas Receitas'),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () => _navigateToReceitasCurtidas(context),
          style: ElevatedButton.styleFrom(
            primary: Colors.brown[400], // Cor do botão "Receitas Curtidas"
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.favorite),
              SizedBox(width: 8.0),
              Text('Receitas Curtidas'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoggedOutBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'E-mail'),
        ),
        SizedBox(height: 12.0),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Senha'),
          obscureText: true,
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () => _login(context),
          child: Text('Entrar'),
          style: ElevatedButton.styleFrom(
            primary: Colors.brown[400], // Cor do botão de login
          ),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () => _navigateToCadastro(context),
          child: Text('Cadastrar'),
          style: ElevatedButton.styleFrom(
            primary: Colors.brown[400], // Cor do botão de cadastro
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
    theme: ThemeData(
      primarySwatch: Colors.brown,
      hintColor: Colors.brown[700],
    ),
  ));
}