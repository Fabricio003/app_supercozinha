import 'package:flutter/material.dart';

class SearchPage extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.deepOrange),
          iconSize: 35.0,
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text("Resultados para: $query"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
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
