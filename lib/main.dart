import 'package:flutter/material.dart';
import 'package:flutter_mobile_app/pages/login.page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuperCozinha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
      ),
      home: LoginPage()
    );
  }
}

