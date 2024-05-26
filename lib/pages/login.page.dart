import 'package:flutter/material.dart';
import 'package:flutter_mobile_app/pages/home.page.dart';
import 'package:flutter_mobile_app/pages/reset-password.page.dart';
import 'package:flutter_mobile_app/pages/signup.page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

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
              width: 350, // Defina a largura desejada aqui
              height: 510, // Defina a altura desejada aqui
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
                        height: 60,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: SizedBox.expand(
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 30),
                                  child: SizedBox(
                                    child:
                                        Image.asset("images/google_logo.png"),
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Text(
                                  "Login com Google",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black38,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            onPressed: () {
                              /* 
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      ); */
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: SizedBox.expand(
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 30),
                                  child: SizedBox(
                                    child:
                                        Image.asset("images/facebook_logo.png"),
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Text(
                                  "Login com Facebook",
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
                      SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Usuário",
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
                            color: Colors.black,
                            width: 1.0,
                          ),
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 40,
                        child: TextButton(
                          child: Text(
                            "Cadastre-se",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 15,
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