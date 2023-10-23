// Bibliotecas
import 'package:cozinhafacil/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'utils/pallete.dart';
//Telas
import 'screens/login.dart';
import 'screens/cadastro.dart';

import 'screens/conversor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/cadastro': (context) => CadastroScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomePage(),
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
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    Conversor(),
    HomePage(),
    LoginScreen(),
    // Adicione suas outras páginas aqui
  ];

  void _onItemTapped(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 1 ? HomePage() : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee_sharp, color: AppColors.buttonPrimaryColor),
            label: 'Conversor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: AppColors.buttonPrimaryColor),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt, color: AppColors.buttonPrimaryColor),
            label: 'Perfil',
          ),
        ],
        backgroundColor: AppColors.backgroundColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false, // Mostrar rótulo do item selecionado
        showUnselectedLabels: false, // Mostrar rótulo do item não selecionado
        type: BottomNavigationBarType.fixed, // Evitar que os itens se movam
      ),
    );
  }
}
