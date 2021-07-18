import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Rick_and_Morty_wiki/feature/domain/entities/person_entity.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/block/search_bloc/search_bloc.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/block/search_bloc/search_event.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/block/search_bloc/search_state.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/widgets/search_result.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate() : super(searchFieldLabel: 'Search for characters...');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print('Inside custom search delegate and search query is $query');
    BlocProvider.of<PersonSearchBloc>(context, listen: false)..add(SearchPersons(query));
    return BlocBuilder<PersonSearchBloc, PersonSearchState>(
      builder: (context, state) {
        if (state is PersonSearchLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PersonSearchLoaded) {
          final persons = state.persons;
          return Container(
            child: ListView.builder(
              itemBuilder: (context, index) {
                PersonEntity result = persons[index];
                return SingleChildScrollView(
                  child: SearchResult(personResult: result),
                );
              },
              itemCount: persons.length,
            ),
          );
        } else if (state is PersonSearchError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 25,
              ),
            ),
          );
        }
        return Center(
          child: Icon(Icons.now_wallpaper),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length > 0) {
      return buildResults(context);
    }
    return Center(
      child: Column(
        children: [
          SizedBox(height: 150,),
          Text('Enter name', style: TextStyle(fontSize: 25)),
          SizedBox(height: 8,),
          Icon(Icons.search, size: 50),
        ],
      ),
    );
  }
}
