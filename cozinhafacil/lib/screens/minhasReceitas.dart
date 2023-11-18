import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class MyRecipes extends StatefulWidget {
  @override
  _MyRecipesState createState() => _MyRecipesState();
}

class _MyRecipesState extends State<MyRecipes> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  void _removeRecipe(String recipeId) async {
    await FirebaseFirestore.instance.collection('recipes').doc(recipeId).delete();
  }

  void _editRecipe(String recipeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipeScreen(recipeId: recipeId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Receitas'),
        backgroundColor: Colors.brown[200], // Marrom claro
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('recipes')
            .where('userId', isEqualTo: _user.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Você ainda não tem receitas cadastradas.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var recipe = snapshot.data!.docs[index];
              var recipeId = recipe.id;

              return Card(
                margin: EdgeInsets.all(8.0),
                elevation: 2.0,
                child: ListTile(
                  title: Text(recipe['title']),
                  subtitle: Text(recipe['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editRecipe(recipeId),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeRecipe(recipeId),
                      ),
                    ],
                  ),
                  leading: Icon(Icons.restaurant), // Ícone de culinária
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditRecipeScreen extends StatefulWidget {
  final String recipeId;

  EditRecipeScreen({required this.recipeId});

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prepTimeController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadRecipeData();
  }

  void _loadRecipeData() async {
    DocumentSnapshot recipeSnapshot =
        await FirebaseFirestore.instance.collection('recipes').doc(widget.recipeId).get();

    if (recipeSnapshot.exists) {
      setState(() {
        _titleController.text = recipeSnapshot['title'];
        _descriptionController.text = recipeSnapshot['description'];
        _prepTimeController.text = recipeSnapshot['prepTime'];
        _servingsController.text = recipeSnapshot['servings'].toString();
        _ingredientsController.text = recipeSnapshot['ingredients'].join('\n');
        _stepsController.text = recipeSnapshot['steps'].join('\n');
        _imageUrlController.text = recipeSnapshot['imageUrl'];
      });
    }
  }

  Future<void> _selectImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<String> _uploadImage() async {
    if (_image == null) {
      return _imageUrlController.text;
    }

    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    UploadTask uploadTask = storageReference.putFile(_image!);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

    return await snapshot.ref.getDownloadURL();
  }

  void _saveChanges() async {
    try {
      String imageUrl = await _uploadImage();

      await FirebaseFirestore.instance.collection('recipes').doc(widget.recipeId).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'prepTime': _prepTimeController.text,
        'servings': int.parse(_servingsController.text),
        'ingredients': _ingredientsController.text.split('\n'),
        'steps': _stepsController.text.split('\n'),
        'imageUrl': imageUrl,
      });

      Navigator.pop(context); // Voltar à tela anterior após salvar as alterações

      _showAlertDialog('Sucesso', 'Receita editada com sucesso!');
    } catch (error) {
      print('Error saving changes: $error');
      _showAlertDialog('Erro', 'Ocorreu um erro ao salvar as alterações.');
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
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
        title: Text('Editar Receita'),
        backgroundColor: Colors.brown[200], // Marrom claro
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título da Receita'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Breve Descrição'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _prepTimeController,
                decoration: InputDecoration(labelText: 'Tempo de Preparo'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _servingsController,
                decoration: InputDecoration(labelText: 'Porções Servidas'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _ingredientsController,
                decoration: InputDecoration(labelText: 'Ingredientes (um por linha)'),
                maxLines: null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _stepsController,
                decoration: InputDecoration(labelText: 'Passo a Passo (um por linha)'),
                maxLines: null,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _selectImage(),
                child: Text('Selecionar Imagem'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown[400],
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _saveChanges(),
                child: Text('Salvar Alterações'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown[400], // Cor do botão "Salvar Alterações"
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
