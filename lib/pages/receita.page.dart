import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mobile_app/services/auth.service.dart';
import 'package:image/image.dart' as img;

class ReceitaPage extends StatefulWidget {
  final Function(Map<String, String>) onRecipePublished;
  final Map<String, String>? receita;
  final String? receitaId;

  ReceitaPage({required this.onRecipePublished, this.receita, this.receitaId});

  @override
  _ReceitaPageState createState() => _ReceitaPageState();
}

class _ReceitaPageState extends State<ReceitaPage> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _dishNameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _preparationController = TextEditingController();
  final AuthService _authService = AuthService();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uploadedImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.receita != null) {
      _dishNameController.text = widget.receita!['nome']!;
      _ingredientsController.text = widget.receita!['ingredientes']!;
      _preparationController.text = widget.receita!['preparo']!;
      _uploadedImageUrl = widget.receita!['imageUrl'];
    }
  }

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _imageFile = photo;
      });
    }
  }

  Future<void> _saveReceita() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        String? imageUrl = _uploadedImageUrl;

        if (_imageFile != null) {
          String filePath = 'receitas/${user.uid}/${DateTime.now()}.png';

          // Redimensiona a imagem
          File file = File(_imageFile!.path);
          img.Image? image = img.decodeImage(await file.readAsBytes());
          img.Image resized = img.copyResize(image!, width: 500);

          // Converte a imagem redimensionada para Uint8List
          Uint8List pngBytes = Uint8List.fromList(img.encodePng(resized));

          await _storage.ref(filePath).putData(pngBytes);

          imageUrl = await _storage.ref(filePath).getDownloadURL();
        }

        final receita = {
          'nome': _dishNameController.text,
          'ingredientes': _ingredientsController.text,
          'preparo': _preparationController.text,
          'imageUrl': imageUrl ?? '',
        };

        if (widget.receitaId != null) {
          // Edit existing receita
          await _authService.updateReceita(
            userId: userId,
            receitaId: widget.receitaId!,
            receita: receita,
          );
        } else {
          // Add new receita
          await _authService.addReceita(
            userId: userId,
            nome: receita['nome']!,
            ingredientes: receita['ingredientes']!,
            preparo: receita['preparo']!,
            imageUrl: receita['imageUrl']!,
          );
        }

        setState(() {
          _uploadedImageUrl = imageUrl;
          _isLoading = false;
        });

        widget.onRecipePublished(receita);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Receita publicada com sucesso!'),
            backgroundColor: Colors.green,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
          ),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar a receita.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Adicionar Receita',
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepOrange),
          iconSize: 35.0,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (_imageFile != null)
                    Image.file(
                      File(_imageFile!.path),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  if (_uploadedImageUrl != null && _imageFile == null)
                    Image.network(
                      _uploadedImageUrl!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                    ),
                    onPressed: _openCamera,
                    child: Text(
                      'Tirar Foto',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.receitaId != null
                                  ? "Atualizar Receita"
                                  : "Publicar Receita",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onPressed: _saveReceita),
                  ),
                ],
              ),
            ),
    );
  }
}
