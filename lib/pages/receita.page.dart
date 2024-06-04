import 'package:flutter/material.dart';
import 'package:flutter_mobile_app/pages/perfil.page.dart';

class ReceitaPage extends StatelessWidget {
  const ReceitaPage({super.key});

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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nome do Prato',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.add_circle,
                      size: 50, color: Colors.deepOrange),
                  onPressed: () {},
                ),
              ),
            ),
            SizedBox(height: 20),
            const Text(
              'Ingredientes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 7),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Descreva os ingredientes....',
                hintStyle: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            SizedBox(height: 20),
            const Text(
              'Modo de Preparo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 7),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Descreva o modo de preparo....',
                hintStyle: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            SizedBox(height: 40),
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
                      "Publicar receita",
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PerfilPage(),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
