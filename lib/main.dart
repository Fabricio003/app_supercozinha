import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_app/pages/login.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuperCozinha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.spicyRice(
            textStyle: TextStyle(fontSize: 36, color: Colors.white),
          ),
          titleMedium: GoogleFonts.caveat(
            textStyle: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      home: SplashScreen(),
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

  Future<String> getImageUrl(String imageName) async {
    final ref = FirebaseStorage.instance.ref().child('assets/$imageName');
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: FutureBuilder(
          future: getImageUrl('chapeu_chef.png'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network(snapshot.data!),
                    SizedBox(height: 20),
                    Text(
                      'SuperCozinha',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Seja você o maior chef da sua cozinha!',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar imagem');
              }
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}