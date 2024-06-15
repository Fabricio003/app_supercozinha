import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login.page.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background_recover.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Center(
              child: Container(
                width: 350,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Esqueceu sua senha?",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "E-mail",
                              labelStyle: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                            ),
                            style: TextStyle(fontSize: 20),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'O campo E-mail é obrigatório';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: _obscureNewPassword,
                            decoration: InputDecoration(
                              labelText: "Nova senha",
                              labelStyle: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNewPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(fontSize: 20),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'O campo Nova senha é obrigatório';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: _confirmNewPasswordController,
                            obscureText: _obscureConfirmNewPassword,
                            decoration: InputDecoration(
                              labelText: "Confirmar senha",
                              labelStyle: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmNewPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmNewPassword = !_obscureConfirmNewPassword;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(fontSize: 20),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'O campo Confirmar senha é obrigatório';
                              }
                              if (value != _newPasswordController.text) {
                                return 'As senhas não coincidem';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30),
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
                                    "Salvar",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await _resetPassword();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Nova senha registrada com sucesso!'),
                                        backgroundColor: Colors.green,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                        ),
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: Colors.red,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: TextButton(
                              child: Text(
                                "Cancelar",
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    final auth = FirebaseAuth.instance;
    final ref = FirebaseDatabase.instance.ref().child('users');

    final query = ref.orderByChild('email').equalTo(email).limitToFirst(1);
    final snapshot = await query.get();

    if (snapshot.exists) {
      final userKey = snapshot.children.first.key;
      final userData = snapshot.children.first.value as Map;

      final currentPassword = userData['senha'];

      final user = auth.currentUser;
      if (user != null) {
        final cred = EmailAuthProvider.credential(email: email, password: currentPassword);
        try {
          await user.reauthenticateWithCredential(cred);
          await user.updatePassword(newPassword);
          
          await ref.child(userKey!).update({'senha': newPassword});
          
          await auth.signOut();
        } catch (e) {
          throw Exception('Falha na reautenticação. Verifique a senha atual e tente novamente.');
        }
      } else {
        throw Exception('Usuário não encontrado.');
      }
    } else {
      throw Exception('Usuário não encontrado.');
    }
  }
}
