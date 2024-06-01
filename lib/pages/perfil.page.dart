import 'package:flutter/material.dart';
import 'package:flutter_mobile_app/pages/config.page.dart';
import 'package:flutter_mobile_app/pages/login.page.dart';
import 'package:flutter_mobile_app/pages/receita.page.dart';
import 'package:flutter_mobile_app/pages/search.page.dart';

class PerfilPage extends StatefulWidget {
  final int initialTab;

  PerfilPage({this.initialTab = 0});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PerfilPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepOrange),
          iconSize: 35.0,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Minha Conta",
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey),
            onPressed: () {
              showSearch(context: context, delegate: SearchPage());
            },
          ),
          IconButton(
            icon: Icon(Icons.history, color: Colors.grey),
            onPressed: () => {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _buildProfileHeader(),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.deepOrange,
            labelColor: Colors.deepOrange,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Favoritos"),
              Tab(text: "Minhas receitas"),
            ],
            labelStyle: TextStyle(
              fontSize: 15.0,
              color: Colors.deepOrange,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFavoritosTab(),
                _buildMinhasReceitasTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("images/user-picture.png"),
                  ),
                  SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Camila Souza",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("0 receitas"),
                    ],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.deepOrange),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ConfigPage()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.exit_to_app, color: Colors.deepOrange),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirmar saída"),
                            content: Text("Você realmente deseja sair?"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Não"),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Fecha o diálogo
                                },
                              ),
                              TextButton(
                                child: Text("Sim"),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritosTab() {
    return ListView(
      children: <Widget>[
        _buildCardItem(
          "Strogonoff de Frango",
          "images/strogonoff-frango.png",
          "images/user-picture.png",
        ),
        // Adicione mais _buildCardItem conforme necessário
      ],
    );
  }

  Widget _buildMinhasReceitasTab(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Ops...\nParece que você ainda não publicou uma receita",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 20),
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.deepOrange, size: 50),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ReceitaPage()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem(String title, String imagePath, String chefImagePath) {
    return Container(
      margin: EdgeInsets.all(8),
      width: 300.0, // Largura fixa do Card
      height: 256.9, // Altura fixa do Card
      child: Card(
        elevation: 8.0, // Adiciona sombreamento ao card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Borda arredondada
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(chefImagePath),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 16.0, // Tamanho da fonte
                  fontWeight: FontWeight.bold, // Peso da fonte
                  fontFamily: 'Roboto', // Nome da fonte
                  color: Colors.grey.shade800, // Cor do texto
                ),
              ),
              trailing: Icon(Icons.favorite, color: Colors.deepOrange),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit
                    .cover, // Ajusta a imagem para cobrir a largura disponível
                width: double
                    .infinity, // Garante que a imagem ocupe toda a largura
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: PerfilPage()));
