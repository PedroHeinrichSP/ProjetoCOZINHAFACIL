import 'package:flutter/material.dart';
import 'login.dart';
import 'cadastro.dart';
import 'home.dart';
import 'pageTwo.dart';
import 'receita.dart';
import 'package:flutter/cupertino.dart';
import 'sobrePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  String teste = "teste";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
  '/cadastro': (context) => CadastroScreen(),
  '/login': (context) => LoginScreen(),
  '/defaultCard': (context) => DefaultCard(teste, 'erro', teste),
  '/sobre': (context) => SobrePage(), // Rota para a página 'Sobre'
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
    SobrePage()
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

      body: _selectedIndex == 0 ? CardGrid() : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.blue),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee_sharp, color: Colors.green),
            label: 'Página2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt, color: Colors.orange),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: Colors.purple),
            label: 'Sobre',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Cor do item selecionado
        unselectedItemColor: Colors.grey, // Cor do item não selecionado
        showSelectedLabels: true, // Mostrar rótulo do item selecionado
        showUnselectedLabels: true, // Mostrar rótulo do item não selecionado
        type: BottomNavigationBarType.fixed, // Evitar que os itens se movam
      ),
    );
  }
}