import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_mobile_app/pages/login.page.dart';
import 'package:flutter_mobile_app/services/auth.service.dart';
import 'dart:io' show File; // Usado para outras plataformas que não são web
import 'dart:typed_data'; // Usado para web
import 'package:flutter/foundation.dart' show kIsWeb;

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
  bool _newPasswordVisible = false;
  bool _currentPasswordVisible = false;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
  }

  void _loadProfilePicture() async {
    String? imageUrl = await _authService.getProfilePicture();
    setState(() {
      _imageUrl = imageUrl;
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        bool isReauthenticated =
            await _authService.reauthenticate(_currentPasswordController.text);

        if (isReauthenticated) {
          await _authService.updatePassword(_newPasswordController.text);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Senha alterada com sucesso!'),
              backgroundColor: Colors.green,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15))),
            ),
          );

          _currentPasswordController.clear();
          _newPasswordController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Senha atual incorreta.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar a senha: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
            _buildPasswordChangeSection(),
            _buildDeleteAccountButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white, // Define um fundo branco
          backgroundImage: _imageUrl != null && _imageUrl!.isNotEmpty
              ? NetworkImage(_imageUrl!)
              : null,
          radius: 40,
          child: _imageUrl == null || _imageUrl!.isEmpty
              ? Icon(Icons.person, color: Colors.grey, size: 40)
              : null,
        ),
        IconButton(
          icon: Icon(Icons.camera_alt, color: Colors.deepOrange),
          onPressed: _pickImage,
        ),
      ],
    );
  }

  Widget _buildPasswordChangeSection() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          TextFormField(
            controller: _currentPasswordController,
            obscureText: !_currentPasswordVisible,
            decoration: InputDecoration(
              labelText: "Senha atual",
              labelStyle: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(_currentPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _currentPasswordVisible = !_currentPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira a senha atual';
              }
              return null;
            },
          ),
          SizedBox(height: 30),
          TextFormField(
            controller: _newPasswordController,
            obscureText: !_newPasswordVisible,
            decoration: InputDecoration(
              labelText: "Nova senha",
              labelStyle: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(_newPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _newPasswordVisible = !_newPasswordVisible;
                  });
                },
              ),
            ),
            validator: _validateNewPassword,
          ),
          SizedBox(height: 60),
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
                    "Gravar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onPressed: _submitForm,
            ),
          ),
        ],
      ),
    );
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a nova senha';
    } else if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
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
