import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_mobile_app/pages/config.page.dart';
import 'package:flutter_mobile_app/pages/login.page.dart';
import 'package:flutter_mobile_app/pages/receita.page.dart';
import 'package:flutter_mobile_app/pages/search.page.dart';
import 'package:flutter_mobile_app/services/auth.service.dart';

class PerfilPage extends StatefulWidget {
  final int initialTab;
  final String userName;

  PerfilPage({this.initialTab = 0, this.userName = "Usuário"});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final AuthService _authService = AuthService();
  String? _imageUrl;
  List<Map<String, String>> _minhasReceitas = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _loadProfilePicture();
    _loadMinhasReceitas();
  }

  void _loadProfilePicture() async {
    String? imageUrl = await _authService.getProfilePicture();
    setState(() {
      _imageUrl = imageUrl;
    });
  }

  Future<void> _loadMinhasReceitas() async {
    setState(() {
      _isLoading = true;
    });

    User? user = _authService.getCurrentUser();
    if (user != null) {
      final ref = _database.ref('receitas/${user.uid}');
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final receitas = <Map<String, String>>[];
        snapshot.children.forEach((child) {
          final receita = child.value as Map;
          receitas.add({
            'id': child.key!,
            'nome': receita['nome'],
            'ingredientes': receita['ingredientes'],
            'preparo': receita['preparo'],
            'imageUrl': receita['imageUrl'],
          });
        });

        setState(() {
          _minhasReceitas = receitas;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addReceita(Map<String, String> receita) {
    setState(() {
      _minhasReceitas.add(receita);
    });
  }

  Future<void> _deleteReceita(String receitaId) async {
    User? user = _authService.getCurrentUser();
    if (user != null) {
      await _authService.deleteReceita(userId: user.uid, receitaId: receitaId);
      setState(() {
        _minhasReceitas.removeWhere((receita) => receita['id'] == receitaId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Receita deletada com sucesso!'),
          backgroundColor: Colors.red,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        ),
      );
    }
  }

  void _editReceita(Map<String, String> receita, String receitaId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReceitaPage(
          onRecipePublished: (updatedReceita) {
            setState(() {
              final index =
                  _minhasReceitas.indexWhere((r) => r['id'] == receitaId);
              _minhasReceitas[index] = updatedReceita
                ..addAll({'id': receitaId});
            });
          },
          receita: receita,
          receitaId: receitaId,
        ),
      ),
    );
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
            backgroundColor: Colors.white, // Define um fundo branco
            backgroundImage: _imageUrl != null && _imageUrl!.isNotEmpty
                ? NetworkImage(_imageUrl!)
                : null,
            radius: 40,
            child: _imageUrl == null || _imageUrl!.isEmpty
                ? Icon(Icons.person, color: Colors.grey, size: 40)
                : null),
        SizedBox(width: 18),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(displayName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("${_minhasReceitas.length} receitas"),
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
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.deepOrange,
        labelColor: Colors.deepOrange,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Minhas receitas"),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.deepOrange),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReceitaPage(
                            onRecipePublished: _addReceita,
                          ))),
                ),
              ],
            ),
          ),
        ],
        labelStyle: TextStyle(fontSize: 15.0),
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildMinhasReceitasTab(),
        ],
      ),
    );
  }

  Widget _buildMinhasReceitasTab() {
    if (_minhasReceitas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Ops...\nParece que você ainda não publicou uma receita",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.deepOrange, size: 50),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReceitaPage(
                        onRecipePublished: _addReceita,
                      ))),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _minhasReceitas.length,
        itemBuilder: (context, index) {
          final receita = _minhasReceitas[index];
          return _buildCardItem(
            receita['id']!,
            receita['nome']!,
            receita['imageUrl']!,
            receita['ingredientes']!,
            receita['preparo']!,
          );
        },
      );
    }
  }

  Widget _buildCardItem(String receitaId, String title, String imagePath,
      String ingredientes, String preparo) {
    return Container(
      margin: EdgeInsets.all(8),
      width: 300.0,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                  backgroundImage: AssetImage('images/user-picture.png')),
              title: Text(title,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.deepOrange),
                    onPressed: () => _editReceita({
                      'nome': title,
                      'ingredientes': ingredientes,
                      'preparo': preparo,
                      'imageUrl': imagePath,
                    }, receitaId),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.deepOrange),
                    onPressed: () => _deleteReceita(receitaId),
                  ),
                ],
              ),
            ),
            if (imagePath.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Image.network(
                  imagePath,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Ingredientes: $ingredientes\n\nModo de Preparo: $preparo',
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
