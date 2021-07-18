import 'package:Rick_and_Morty_wiki/core/error/failure.dart';
import 'package:Rick_and_Morty_wiki/feature/domain/entities/person_entity.dart';

import 'package:dartz/dartz.dart';

abstract class PersonRepository {
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page);

  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query);
}
