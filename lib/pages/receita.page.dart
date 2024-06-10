import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReceitaPage extends StatefulWidget {
  @override
  _ReceitaPageState createState() => _ReceitaPageState();
}

class _ReceitaPageState extends State<ReceitaPage> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _dishNameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _preparationController = TextEditingController();

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = photo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Receita'),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_imageFile != null) Image.file(File(_imageFile!.path)),
            TextField(
              controller: _dishNameController,
              decoration: InputDecoration(
                hintText: 'Nome do prato',
                hintStyle: TextStyle(fontFamily: 'Roboto'),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(
                hintText: 'Descreva os ingredientes...',
                hintStyle: TextStyle(fontFamily: 'Roboto'),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _preparationController,
              decoration: InputDecoration(
                hintText: 'Descreva o modo de preparo...',
                hintStyle: TextStyle(fontFamily: 'Roboto'),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openCamera,
              child: Text('Tirar Foto'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aqui você pode adicionar a lógica para salvar ou publicar a receita
                print('Receita publicada com sucesso!');
              },
              child: Text('Publicar receita'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Botão laranja para destacar
              ),
            ),
          ],
        ),
      ),
    );
  }
}
