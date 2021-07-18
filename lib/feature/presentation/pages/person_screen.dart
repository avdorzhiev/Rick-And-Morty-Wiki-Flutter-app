import 'package:flutter/material.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/widgets/custom_search_delegate.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/widgets/persons_list_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characters'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: PersonsList(),
    );
  }
}
