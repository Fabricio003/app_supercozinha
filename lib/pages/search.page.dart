import 'package:flutter/material.dart';

class SearchPage extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // Ações para limpar ou manipular o conteúdo da pesquisa
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ""; // Limpa a pesquisa
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Ícone à esquerda da barra de pesquisa
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.deepOrange),
          iconSize: 35.0,
      onPressed: () {
        close(context, ''); // Fecha a tela de pesquisa
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Cria os resultados a serem mostrados
    return Center(
      child: Text("Resultados para: $query"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugestões que aparecem quando o usuário digita algo
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.history),
          title: Text('Pesquisa recente 1'),
          onTap: () {
            query = 'Pesquisa recente 1';
          },
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('Pesquisa recente 2'),
          onTap: () {
            query = 'Pesquisa recente 2';
          },
        ),
      ],
    );
  }
}
