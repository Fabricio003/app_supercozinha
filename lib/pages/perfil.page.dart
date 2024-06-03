import 'package:flutter/material.dart';
import 'package:flutter_mobile_app/pages/config.page.dart';
import 'package:flutter_mobile_app/pages/login.page.dart';
import 'package:flutter_mobile_app/pages/receita.page.dart';
import 'package:flutter_mobile_app/pages/search.page.dart';

class PerfilPage extends StatefulWidget {
  final int initialTab;
  final String userName;

  PerfilPage({this.initialTab = 0, this.userName = "Usuário"});

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
        elevation: 1,
        leading: null,
        title: Text("Minha Conta",
            style: TextStyle(
                color: Colors.deepOrange, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search, color: Colors.grey),
              onPressed: () =>
                  showSearch(context: context, delegate: SearchPage())),
          IconButton(
              icon: Icon(Icons.history, color: Colors.grey), onPressed: () {}),
        ],
      ),
      body: Column(
        children: <Widget>[
          _buildProfileHeader(),
          _buildTabBar(),
          _buildTabBarView(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    String displayName =
        widget.userName.isNotEmpty ? widget.userName : "Usuário";
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildUserInfo(displayName),
              _buildUserActions(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(String displayName) {
    return Row(
      children: <Widget>[
        CircleAvatar(
            radius: 40, backgroundImage: AssetImage("images/user-picture.png")),
        SizedBox(width: 18),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(displayName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("0 receitas"),
          ],
        ),
      ],
    );
  }

  Widget _buildUserActions() {
    return Row(
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.settings, color: Colors.deepOrange),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ConfigPage()))),
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
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text("Sim"),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Colors.deepOrange,
      labelColor: Colors.deepOrange,
      unselectedLabelColor: Colors.grey,
      tabs: [Tab(text: "Favoritos"), Tab(text: "Minhas receitas")],
      labelStyle: TextStyle(fontSize: 15.0),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildFavoritosTab(),
          _buildMinhasReceitasTab(),
        ],
      ),
    );
  }

  Widget _buildFavoritosTab() {
    return ListView(
      children: <Widget>[
        _buildCardItem("Strogonoff de Frango", "images/strogonoff-frango.png",
            "images/user-picture.png"),
        // Adicione mais itens conforme necessário
      ],
    );
  }

  Widget _buildMinhasReceitasTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Ops...\nParece que você ainda não publicou uma receita",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          IconButton(
              icon: Icon(Icons.add_circle, color: Colors.deepOrange, size: 50),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ReceitaPage()))),
        ],
      ),
    );
  }

  Widget _buildCardItem(String title, String imagePath, String chefImagePath) {
    return Container(
      margin: EdgeInsets.all(8),
      width: 300.0,
      height: 256.9,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(backgroundImage: AssetImage(chefImagePath)),
              title: Text(title,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800)),
              trailing: Icon(Icons.favorite, color: Colors.deepOrange),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              child: Image.asset(imagePath,
                  fit: BoxFit.cover, width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
