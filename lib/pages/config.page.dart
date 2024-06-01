import 'package:flutter/material.dart';
import 'package:flutter_mobile_app/pages/login.page.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Senha alterada com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white, // Define o fundo como branco
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
          backgroundImage: AssetImage('images/user-picture.png'),
          radius: 40,
        ),
        IconButton(
          icon: Icon(Icons.camera_alt, color: Colors.deepOrange),
          onPressed: () {
            // Add functionality for changing the profile picture here
          },
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
          SizedBox(height: 60),
          TextFormField(
            controller: _newPasswordController,
            obscureText: !_newPasswordVisible,
            decoration: InputDecoration(
              labelText: "Senha atual",
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
            validator: (value) => _validateNotEmpty(value, 'a senha'),
          ),
          SizedBox(height: 30),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_confirmPasswordVisible,
            decoration: InputDecoration(
              labelText: "Nova senha",
              labelStyle: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(_confirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _confirmPasswordVisible = !_confirmPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) => _validatePasswords(value),
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
              child: Text("Gravar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center),
              onPressed: _submitForm,
            ),
          ),
        ],
      ),
    );
  }

  String? _validatePasswords(String? value) {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira $fieldName';
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
            minimumSize: Size(double.infinity,
                50), // Ocupa toda a largura disponível e tem altura de 50 pixels
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
              onPressed: () {
                // Implemente a lógica de exclusão da conta aqui
                Navigator.of(context).pop(); // Fecha o diálogo
                _redirectToLoginPage(); // Chama o método para redirecionar para a página de login
              },
            ),
          ],
        );
      },
    );
  }

  void _redirectToLoginPage() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) =>
              LoginPage()), // Substitua 'LoginPage()' pela sua página de login
      (Route<dynamic> route) => false,
    );
  }
}
