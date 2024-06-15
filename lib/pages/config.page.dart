import 'package:flutter/material.dart';
import 'package:flutter_mobile_app/pages/perfil.page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_mobile_app/pages/login.page.dart';
import 'package:flutter_mobile_app/services/auth.service.dart';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final AuthService _authService = AuthService();
  String? _imageUrl;
  String? _userName;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileInfo();
  }

  void _loadProfileInfo() async {
    String? imageUrl = await _authService.getProfilePicture();
    String? userName = await _authService.getUserName();
    setState(() {
      _imageUrl = imageUrl;
      _userName = userName;
      _nameController.text = '';
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      String url;
      if (kIsWeb) {
        Uint8List fileBytes = await pickedFile.readAsBytes();
        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('profile_pictures/${DateTime.now().millisecondsSinceEpoch}');
        final UploadTask uploadTask = storageReference.putData(fileBytes);
        final TaskSnapshot downloadUrl = await uploadTask;
        url = await downloadUrl.ref.getDownloadURL();
      } else {
        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('profile_pictures/${DateTime.now().millisecondsSinceEpoch}');
        final UploadTask uploadTask =
            storageReference.putFile(File(pickedFile.path));
        final TaskSnapshot downloadUrl = await uploadTask;
        url = await downloadUrl.ref.getDownloadURL();
      }

      setState(() {
        _imageUrl = url;
      });

      await _authService.updateProfilePicture(url);
    }
  }

  Future<void> _updateUserName() async {
    String newName = _nameController.text.trim();
    if (newName.isNotEmpty) {
      await _authService.updateUserName(newName);
      setState(() {
        _userName = newName;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PerfilPage(userName: newName),
        ),
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
          'Configurações',
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            _buildProfileHeader(),
            SizedBox(height: 20),
            _buildNameField(),
            SizedBox(height: 20),
            _buildSaveButton(),
            _buildDeleteAccountButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: _imageUrl != null && _imageUrl!.isNotEmpty
                ? NetworkImage(_imageUrl!)
                : null,
            radius: 40,
            child: _imageUrl == null || _imageUrl!.isEmpty
                ? Icon(Icons.person, color: Colors.grey, size: 40)
                : null,
          ),
        ),
        SizedBox(height: 10),
        IconButton(
          icon: Icon(Icons.camera_alt, color: Colors.deepOrange),
          onPressed: _pickImage,
        ),
        SizedBox(height: 10),
        Text(
          _userName ?? 'Usuário',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: 'Nome',
        hintStyle: TextStyle(fontFamily: 'Roboto'),
      ),
      maxLines: 1,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        minimumSize: Size(double.infinity, 50),
      ),
      onPressed: _updateUserName,
      child: Text(
        'Salvar',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return Column(
      children: [
        SizedBox(height: 100),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10),
            )),
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: () => _showDeleteAccountDialog(),
          child: Text(
            'Deletar conta',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Deletar Conta"),
          content: Text(
              "Tem certeza que deseja deletar sua conta? Esta ação é irreversível."),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Deletar", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _authService.deleteUser();
                  _redirectToLoginPage();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao deletar conta: $e')),
                  );
                }
              },
            )
          ],
        );
      },
    );
  }

  void _redirectToLoginPage() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
