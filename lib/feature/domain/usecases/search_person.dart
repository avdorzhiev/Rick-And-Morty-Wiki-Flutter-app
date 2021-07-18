import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:Rick_and_Morty_wiki/core/error/failure.dart';
import 'package:Rick_and_Morty_wiki/core/usecases/usecase.dart';
import 'package:Rick_and_Morty_wiki/feature/domain/entities/person_entity.dart';
import 'package:Rick_and_Morty_wiki/feature/domain/repositories/person_repository.dart';

class SearchPerson extends UseCase<List<PersonEntity>, SearchPersonParams> {
  final PersonRepository personRepository;

  SearchPerson(this.personRepository);

  Future<Either<Failure, List<PersonEntity>>> call(
      SearchPersonParams params) async {
    return await personRepository.searchPerson(params.query);
  }
}

class SearchPersonParams extends Equatable {
  final String query;

  SearchPersonParams({required this.query});

  @override
  List<Object?> get props => [query];
}
