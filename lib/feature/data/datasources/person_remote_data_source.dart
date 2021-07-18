import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Rick_and_Morty_wiki/core/error/exception.dart';
import 'package:Rick_and_Morty_wiki/feature/data/models/person_model.dart';
import 'package:http/http.dart' as http;
import 'package:Rick_and_Morty_wiki/feature/presentation/block/person_list_cubit/person_list_cubit.dart';

abstract class PersonRemoteDataSource {
  Future<List<PersonModel>> getAllPersons(int page);

  Future<List<PersonModel>> searchPerson(String query);
}

const String pathApi = 'https://rickandmortyapi.com/api/character';

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  final http.Client client;

  PersonRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PersonModel>> getAllPersons(int page) => _getPersonFromUrl(pathApi + '/?page=$page');

  @override
  Future<List<PersonModel>> searchPerson(String query) => _getPersonFromUrl(pathApi + '/?name=$query');

  Future<List<PersonModel>> _getPersonFromUrl(String url) async {
    print(url);
    final response = await client.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final persons = json.decode(response.body);
      return (persons['results'] as List).map((person) => PersonModel.fromJson(person)).toList();
    } else {
      throw ServerException();
    }
  }
}
