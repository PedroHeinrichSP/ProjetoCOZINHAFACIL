import 'package:flutter/material.dart';
import 'login.dart';
import 'cadastro.dart';
import 'home.dart';
import 'pageTwo.dart';
import 'receita.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  String teste = "teste";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/cadastro': (context) => CadastroScreen(), // Rota para a tela de cadastro em perfil.dart
        '/login': (context) => LoginScreen(),
        '/defaultCard': (context) => DefaultCard(teste,'erro',teste),
      },
    );
    
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    
    CardGrid(),
    PageTwo(),
    LoginScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cozinha Fácil'),
      ),
      body: _selectedIndex == 0
          ? CardGrid()
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Página 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee_sharp),
            label: 'Home',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

