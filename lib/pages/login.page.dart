import 'package:flutter/material.dart';
import 'package:flutter_mobile_app/pages/perfil.page.dart';
import 'package:flutter_mobile_app/pages/reset-password.page.dart';
import 'package:flutter_mobile_app/pages/signup.page.dart';
import 'package:flutter_mobile_app/services/auth.service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  bool _obscureText = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Center(
          child: Container(
              width: 350,
              height: 510,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: SizedBox.expand(
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: SizedBox(
                                    child:
                                        Image.asset("images/google_logo.png"),
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Text(
                                  "Continuar com Google",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black38,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: SizedBox.expand(
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: SizedBox(
                                    child:
                                        Image.asset("images/facebook_logo.png"),
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Text(
                                  "Continuar com Facebook",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black38,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        controller: emailController,
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
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 2),
                      Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          child: Text(
                            "Recuperar Senha",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPasswordPage(),
                              ),
                            );
                          },
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
                                "Entrar",
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
                            try {
                              await _authService.loginUser(
                                emailController.text,
                                passwordController.text,
                              );
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => PerfilPage(
                                      userName: _authService
                                              .getCurrentUser()
                                              ?.displayName ??
                                          "Usuário"),
                                ),
                              );
                            } on Exception catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e
                                      .toString()
                                      .replaceAll('Exception: ', '')),
                                  backgroundColor: Colors.red,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15))),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 40,
                        child: TextButton(
                          child: Text(
                            "Ainda não tem conta? \nCadastre-se agora",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 14.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
