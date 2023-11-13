import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cozinhafacil/utils/pallete.dart';

void main() {
  runApp(MaterialApp(
    home: RecipeForm(),
  ));
}

class RecipeForm extends StatefulWidget {
  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;

  String _recipeTitle = '';
  String _description = '';
  String _prepTime = '';
  int? _servings;
  List<String> _ingredients = [];
  List<String> _steps = [];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Envie os detalhes da receita para onde desejar, como um banco de dados, etc.
      // Aqui, você pode usar os valores das variáveis _recipeTitle, _description, _prepTime, _servings, _ingredients, _steps e _image.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de Novas Receitas',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20), // Espaço entre o topo e o primeiro campo
            Text(
              'Informações Básicas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 10), // Espaço entre o título e o campo
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Título da Receita',
                labelStyle: TextStyle(color: AppColors.textColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, insira o título da receita';
                }
                return null;
              },
              onSaved: (value) {
                _recipeTitle = value!;
              },
            ),
            SizedBox(height: 20), // Espaço entre os campos
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Breve Descrição',
                labelStyle: TextStyle(color: AppColors.textColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              maxLines: null,
              onSaved: (value) {
                _description = value!;
              },
            ),
            SizedBox(height: 20), // Espaço entre os campos
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Tempo de Preparo',
                labelStyle: TextStyle(color: AppColors.textColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, insira o tempo de preparo';
                }
                return null;
              },
              onSaved: (value) {
                _prepTime = value!;
              },
            ),
            SizedBox(height: 20), // Espaço entre os campos
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Porções Servidas',
                labelStyle: TextStyle(color: AppColors.textColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              items: List.generate(20, (index) => index + 1).map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return 'Por favor, selecione a quantidade de porções';
                }
                return null;
              },
              onChanged: (int? value) {
                setState(() {
                  _servings = value;
                });
              },
            ),
            SizedBox(height: 30), // Espaço entre os campos
            Text(
              'Ingredientes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 10), // Espaço entre o título e o campo
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Insira os ingredientes (um por linha)',
                labelStyle: TextStyle(color: AppColors.textColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              maxLines: null,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, insira os ingredientes';
                }
                return null;
              },
              onSaved: (value) {
                _ingredients = value!.split('\n');
              },
            ),
            SizedBox(height: 20), // Espaço entre os campos
            Text(
              'Passo a Passo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 10), // Espaço entre o título e o campo
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Insira o passo a passo (um por linha)',
                labelStyle: TextStyle(color: AppColors.textColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
              maxLines: null,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, insira os passos';
                }
                return null;
              },
              onSaved: (value) {
                _steps = value!.split('\n');
              },
            ),
            SizedBox(height: 30), // Espaço entre os campos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryColor,
                    onPrimary: Colors.black,
                  ),
                  onPressed: () async {
                    final XFile? image =
                        await _imagePicker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _image = File(image.path);
                      });
                    }
                  },
                  child: Text('Upload de uma Imagem'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryColor,
                    onPrimary: Colors.black,
                  ),
                  onPressed: _submitForm,
                  child: Text('Enviar Receita'),
                ),
              ],
            ),
            _image != null
                ? Image.file(
                    _image!,
                    height: 150,
                    width: 150,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
