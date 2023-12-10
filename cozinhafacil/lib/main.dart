import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'utils/pallete.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login.dart';
import 'screens/cadastro.dart';
import 'screens/cadastroReceitas.dart';
import 'screens/conversor.dart';
import 'screens/homepage.dart';
import 'screens/sobrePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/cadastro': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomePage(),
        '/cadastro_receitas': (context) => RecipeForm(),
        '/sobre': (context) => SobrePage(), // Adicionado rota para a página 'SobrePage'
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    Conversor(),
    HomePage(),
    LoginScreen(),
    SobrePage(),
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
      body: _pages[_selectedIndex],
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
            label: 'Login', // Alterado o rótulo para "Login"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: AppColors.buttonPrimaryColor),
            label: 'Sobre', // Adicionado rótulo para "Sobre"
          ),
        ],
        backgroundColor: AppColors.backgroundColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
