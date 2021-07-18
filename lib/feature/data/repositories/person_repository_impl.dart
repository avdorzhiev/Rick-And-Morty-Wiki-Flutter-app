import 'package:dartz/dartz.dart';
import 'package:Rick_and_Morty_wiki/core/error/exception.dart';
import 'package:Rick_and_Morty_wiki/core/error/failure.dart';
import 'package:Rick_and_Morty_wiki/core/platform/network_info.dart';
import 'package:Rick_and_Morty_wiki/feature/data/datasources/person_local_data_source.dart';
import 'package:Rick_and_Morty_wiki/feature/data/datasources/person_remote_data_source.dart';
import 'package:Rick_and_Morty_wiki/feature/data/models/person_model.dart';
import 'package:Rick_and_Morty_wiki/feature/domain/entities/person_entity.dart';
import 'package:Rick_and_Morty_wiki/feature/domain/repositories/person_repository.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource remoteDataSource;
  final PersonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PersonRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page) async {
    return _getPersons(() => remoteDataSource.getAllPersons(page));
  }

  @override
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query) async {
    return _getPersons(() => remoteDataSource.searchPerson(query));
  }

  Future<Either<Failure, List<PersonEntity>>> _getPersons(Future<List<PersonModel>> Function() callback) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePerson = await callback();
        localDataSource.personsToCache(remotePerson);
        return Right(remotePerson);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cachePerson = await localDataSource.getLastPersonsFromCache();
        return Right(cachePerson);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
