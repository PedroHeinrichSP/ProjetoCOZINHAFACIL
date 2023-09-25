import 'package:cozinhafacil/utils/pallete.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Conversor(),
  ));
}

class Conversor extends StatefulWidget {
  @override
  _ConversorState createState() => _ConversorState();
}

class _ConversorState extends State<Conversor> {
  TextEditingController quantidadeController = TextEditingController();
  String resultado = '';
  bool mostrarResultado = false;

  String selectedIngrediente = 'Arroz';
  String selectedMedida1 = 'Colher';
  String selectedMedida2 = 'Colher';
  double quantidade = 0.0;

  List<String> ingredientes = ['Arroz', 'Feijão', 'Açúcar', 'Farinha'];
  List<String> medidas = ['Colher', 'Copo americano', 'Xícara', 'Gramas', 'Quilos'];

  void converter() {
    double valor = double.tryParse(quantidadeController.text) ?? 0;

    // Realize a lógica de conversão que você precisa aqui
    // Por exemplo, se deseja converter gramas para ml, faça a conversão aqui.
    double resultadoConversao = valor * 1.0; 

    setState(() {
      resultado = 'Resultado: $resultadoConversao'; 
      mostrarResultado = true; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Tela de Cadastro',
          style: TextStyle(
            color: AppColors.textColor, // Define a cor do texto da AppBar como preto
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Medidas\nEquivalentes',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: DropdownButtonFormField<String>(
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
                  decoration: InputDecoration(
                    labelText: 'Ingrediente',
                  ),
                ),
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 8),
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
                        decoration: InputDecoration(
                          labelText: 'Medida 1',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16, left: 8, right: 16),
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
                        decoration: InputDecoration(
                          labelText: 'Medida 2',
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: quantidadeController,
                  decoration: InputDecoration(
                    labelText: 'Quantidade',
                  ),
                ),
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: converter,
                child: Text('Converter'),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, 
                    backgroundColor: Color.fromARGB(255, 218, 175, 167), 
                  ),
              ),
              SizedBox(height: 16),
              if (mostrarResultado) // Mostra o resultado somente se mostrarResultado for true
                Container(
                  child: Text(
                    resultado,
                    style: TextStyle(
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
