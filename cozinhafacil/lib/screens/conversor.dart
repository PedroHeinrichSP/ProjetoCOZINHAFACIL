import 'package:flutter/material.dart';
import 'package:cozinhafacil/utils/pallete.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Conversor(),
  ));
}

class Conversor extends StatefulWidget {
  const Conversor({super.key});

  @override
  _ConversorState createState() => _ConversorState();
}

class _ConversorState extends State<Conversor> {
  TextEditingController quantidadeController = TextEditingController();
  String resultado = '';
  bool mostrarResultado = false;

  String selectedIngrediente = 'Arroz';
  String selectedMedida1 = 'Colheres de Chá';
  String selectedMedida2 = 'Colheres de Chá';
  double quantidade = 0.0;

  Map<String, Map<String, double>> medidasEquivalentes = {
    'Arroz': {
      'Colheres de Chá': 4,
      'Colheres de Sobremesa': 8,
      'Colheres de Sopa': 12,
      'Copos Americanos': 150,
      'Xícaras de Chá': 185,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Amido de Milho': {
      'Colheres de Chá': 3,
      'Colheres de Sobremesa': 6,
      'Colheres de Sopa': 8,
      'Copos Americanos': 105,
      'Xícaras de Chá': 128,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Açúcar': {
      'Colheres de Chá': 4,
      'Colheres de Sobremesa': 8,
      'Colheres de Sopa': 12,
      'Copos Americanos': 148,
      'Xícaras de Chá': 180,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Aveia': {
      'Colheres de Chá': 2,
      'Colheres de Sobremesa': 4,
      'Colheres de Sopa': 6,
      'Copos Americanos': 66,
      'Xícaras de Chá': 80,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Bicarbonato/Fermento': {
      'Colheres de Chá': 5,
      'Colheres de Sobremesa': 10,
      'Colheres de Sopa': 14,
      'Copos Americanos': 184,
      'Xícaras de Chá': 224,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Café em Pó': {
      'Colheres de Chá': 2,
      'Colheres de Sobremesa': 4,
      'Colheres de Sopa': 5,
      'Copos Americanos': 66,
      'Xícaras de Chá': 80,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Castanhas': {
      'Colheres de Chá': 3,
      'Colheres de Sobremesa': 6,
      'Colheres de Sopa': 9,
      'Copos Americanos': 115,
      'Xícaras de Chá': 140,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Chocolate em Pó': {
      'Colheres de Chá': 2,
      'Colheres de Sobremesa': 4,
      'Colheres de Sopa': 6,
      'Copos Americanos': 74,
      'Xícaras de Chá': 90,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Coco Ralado Fresco': {
      'Colheres de Chá': 2,
      'Colheres de Sobremesa': 4,
      'Colheres de Sopa': 6,
      'Copos Americanos': 82,
      'Xícaras de Chá': 100,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Farinha de Trigo': {
      'Colheres de Chá': 2.5,
      'Colheres de Sobremesa': 5,
      'Colheres de Sopa': 7.5,
      'Copos Americanos': 98.5,
      'Xícaras de Chá': 120,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Fubá': {
      'Colheres de Chá': 2.6,
      'Colheres de Sobremesa': 5.25,
      'Colheres de Sopa': 7.9,
      'Copos Americanos': 104,
      'Xícaras de Chá': 126,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Manteiga': {
      'Colheres de Chá': 4.2,
      'Colheres de Sobremesa': 8.4,
      'Colheres de Sopa': 12.5,
      'Copos Americanos': 165,
      'Xícaras de Chá': 200,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Pasta de Amendoim': {
      'Colheres de Chá': 5.4,
      'Colheres de Sobremesa': 10.8,
      'Colheres de Sopa': 16,
      'Copos Americanos': 212,
      'Xícaras de Chá': 258,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Polvilho Doce e Azedo': {
      'Colheres de Chá': 2.6,
      'Colheres de Sobremesa': 5.2,
      'Colheres de Sopa': 8,
      'Copos Americanos': 105,
      'Xícaras de Chá': 128,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Sal Comum': {
      'Colheres de Chá': 6,
      'Colheres de Sobremesa': 12,
      'Colheres de Sopa': 18,
      'Copos Americanos': 236,
      'Xícaras de Chá': 288,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
    'Queijo Ralado': {
      'Colheres de Chá': 2,
      'Colheres de Sobremesa': 4,
      'Colheres de Sopa': 6,
      'Copos Americanos': 74,
      'Xícaras de Chá': 90,
      'Onças (oz)': 30,
      'Gramas (g)': 1,
      'Pounds / Libras (lb)': 450,
      'Quilogramas (kg)': 1000,
    },
  };

  List<String> ingredientes = [
    'Arroz',
    'Amido de Milho',
    'Açúcar',
    'Aveia',
    'Bicarbonato/Fermento',
    'Café em Pó',
    'Castanhas',
    'Chocolate em Pó',
    'Coco Ralado Fresco',
    'Farinha de Trigo',
    'Fubá',
    'Manteiga',
    'Pasta de Amendoim',
    'Polvilho Doce e Azedo',
    'Sal Comum',
    'Queijo Ralado',
  ];

  List<String> medidas = [
    'Colheres de Chá',
    'Colheres de Sobremesa',
    'Colheres de Sopa',
    'Copos Americanos',
    'Xícaras de Chá',
    'Onças (oz)',
    'Gramas (g)',
    'Pounds / Libras (lb)',
    'Quilogramas (kg)'
  ];

  void converter() {
    double valor = double.tryParse(quantidadeController.text) ?? 0;
    double medida1 =
        medidasEquivalentes[selectedIngrediente]![selectedMedida1] ?? 1;
    double medida2 =
        medidasEquivalentes[selectedIngrediente]![selectedMedida2] ?? 1;

    double resultadoConversao = (valor * medida1) / medida2;
    resultadoConversao = double.parse(resultadoConversao.toStringAsFixed(2));

    setState(() {
      resultado =
          'Resultado: $resultadoConversao ${selectedMedida2.toLowerCase()}';
      mostrarResultado = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.brown[200], // Cor marrom claro
        iconTheme: const IconThemeData(
          color: AppColors.textColor,
        ),
        title: const Text(
          'Conversor de Medidas',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                child: Text(
                  'Medidas Equivalentes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedIngrediente,
                onChanged: (newValue) {
                  setState(() {
                    selectedIngrediente = newValue!;
                  });
                },
                items: ingredientes.map((ingrediente) {
                  return DropdownMenuItem<String>(
                    value: ingrediente,
                    child: Text(ingrediente),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Ingrediente',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: DropdownButtonFormField<String>(
                  value: selectedMedida1,
                  onChanged: (newValue) {
                    setState(() {
                      selectedMedida1 = newValue!;
                    });
                  },
                  items: medidas.map((medida) {
                    return DropdownMenuItem<String>(
                      value: medida,
                      child: Text(medida),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'De',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: DropdownButtonFormField<String>(
                  value: selectedMedida2,
                  onChanged: (newValue) {
                    setState(() {
                      selectedMedida2 = newValue!;
                    });
                  },
                  items: medidas.map((medida) {
                    return DropdownMenuItem<String>(
                      value: medida,
                      child: Text(medida),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Para',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: quantidadeController,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ElevatedButton(
                  onPressed: converter,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.buttonSecondaryColor),
                  ),
                  child: const Text('Converter'),
                ),
              ),
              if (mostrarResultado)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    resultado,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}