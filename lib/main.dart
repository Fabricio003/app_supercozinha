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
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
              fontFamily: 'Spicy Rice', fontSize: 36, color: Colors.white),
          titleMedium: TextStyle(
              fontFamily: 'Caveat', fontSize: 20, color: Colors.white),
        ),
      ),
      home: SplashScreen(), // Start with the splash screen
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/chapeu_chef.png'),
            SizedBox(height: 20),
            Text(
              'SuperCozinha',
              style: TextStyle(
                fontFamily: 'Spicy Rice',
                fontSize: 36,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Seja você o maior chef da sua cozinha!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
