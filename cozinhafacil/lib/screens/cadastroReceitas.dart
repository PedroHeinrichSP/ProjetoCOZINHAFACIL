import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Recipe {
  late String title;
  late String description;
  late String prepTime;
  late int? servings;
  late List<String> ingredients;
  late List<String> steps;
  late String imageUrl;
  late List<String> likes;
}

void main() {
  runApp(MaterialApp(
    home: RecipeForm(),
  ));
}

class RecipeForm extends StatefulWidget {
  final String? userId;

  RecipeForm({Key? key, this.userId}) : super(key: key);

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;
  Recipe _recipe = Recipe();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    // Formatando o título da receita
    _recipe.title = _formatRecipeTitle(_recipe.title);

     // Verificando se uma imagem foi selecionada
    if (_image == null) {
      // Exibindo um erro se nenhuma imagem foi selecionada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecione uma imagem para a receita.'),
        ),
      );
      return; // Encerrando a função se nenhuma imagem foi selecionada
    }

    // Upload da imagem para o Firebase Storage
    _recipe.imageUrl = await _uploadImage();

    // Geração do ID único da receita
    String recipeId = await _generateRecipeId();

    // IDs dos usuários que deram like inicialmente vazios
    List<String> initialLikes = [];

    // Envio dos detalhes da receita para o Firestore
    final User? user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('recipes').doc(recipeId).set({
        'recipeId': recipeId, // Incluindo o ID da receita
        'userId': widget.userId,
        'likes': initialLikes,
        'title': _recipe.title,
        'description': _recipe.description,
        'prepTime': _recipe.prepTime,
        'servings': _recipe.servings,
        'ingredients': _recipe.ingredients,
        'steps': _recipe.steps,
        'imageUrl': _recipe.imageUrl,
      });

      // Limpar o formulário
      _formKey.currentState!.reset();

      // Limpar a imagem
      setState(() {
        _image = null;
        _recipe = Recipe();
      });

      // Exibir o resultado do cadastro em um AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cadastro de Receita'),
            content: Text('Receita cadastrada com sucesso!'),
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
  }
}

String _formatRecipeTitle(String title) {
  if (title.isEmpty) {
    return title;
  }

  // Transformar a primeira letra em maiúsculo e o resto em minúsculo
  return title[0].toUpperCase() + title.substring(1).toLowerCase();
}

  Future<String> _uploadImage() async {
    if (_image == null) {
      return '';
    }

    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    UploadTask uploadTask = storageReference.putFile(_image!);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

    return await snapshot.ref.getDownloadURL();
  }

  Future<String> _generateRecipeId() async {
    // Recupera a última receita cadastrada
    QuerySnapshot query = await FirebaseFirestore.instance.collection('recipes').orderBy('recipeId', descending: true).limit(1).get();

    // Obtém o último ID cadastrado
    String lastRecipeId = query.docs.isEmpty ? '0000' : query.docs.first['recipeId'];

    // Gera um novo ID incrementando o último
    int newId = int.parse(lastRecipeId) + 1;
    String newRecipeId = newId.toString().padLeft(4, '0');

    return newRecipeId;
  }
bool isNumeric(String? value) {
  if (value == null) {
    return false;
  }
  return double.tryParse(value) != null;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de Novas Receitas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[200], // Cor marrom claro
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              Text(
                'Informações Básicas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700], // Cor marrom mais escura
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Título da Receita',
                  labelStyle: TextStyle(color: Colors.brown[700]), // Cor marrom mais escura
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown[700]!),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o título da receita';
                  }
                  return null;
                },
                onSaved: (value) {
                  _recipe.title = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Breve Descrição',
                  labelStyle: TextStyle(color: Colors.brown[700]), // Cor marrom mais escura
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown[700]!),
                  ),
                ),
                maxLines: null,
                onSaved: (value) {
                  _recipe.description = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
  decoration: InputDecoration(
    labelText: 'Tempo de Preparo em minutos',
    labelStyle: TextStyle(color: Colors.brown[700]), // Cor marrom mais escura
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.brown[200]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.brown[700]!),
    ),
  ),
  validator: (value) {
    if (value!.isEmpty) {
      return 'Por favor, insira o tempo de preparo';
    }
    if (!isNumeric(value)) {
      return 'Por favor, insira apenas números';
    }
    return null;
  },
  onSaved: (value) {
    _recipe.prepTime = value!;
  },
),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Porções Servidas',
                  labelStyle: TextStyle(color: Colors.brown[700]), // Cor marrom mais escura
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown[700]!),
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
                    _recipe.servings = value;
                  });
                },
              ),
              SizedBox(height: 30),
              Text(
                'Ingredientes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700], // Cor marrom mais escura
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Insira os ingredientes (um por linha)',
                  labelStyle: TextStyle(color: Colors.brown[700]), // Cor marrom mais escura
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown[700]!),
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
                  _recipe.ingredients = value!.split('\n');
                },
              ),
              SizedBox(height: 20),
              Text(
                'Passo a Passo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700], // Cor marrom mais escura
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Insira o passo a passo (um por linha)',
                  labelStyle: TextStyle(color: Colors.brown[700]), // Cor marrom mais escura
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown[700]!),
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
                  _recipe.steps = value!.split('\n');
                },
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.brown[700], // Cor marrom mais escura
                      onPrimary: Colors.white,
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
                      primary: Colors.brown[700], // Cor marrom mais escura
                      onPrimary: Colors.white,
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
      ),
    );
  }
}