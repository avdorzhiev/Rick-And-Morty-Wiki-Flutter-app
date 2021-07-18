import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Rick_and_Morty_wiki/core/error/failure.dart';
import 'package:Rick_and_Morty_wiki/feature/domain/usecases/search_person.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/block/search_bloc/search_event.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/block/search_bloc/search_state.dart';

const SERVER_FAILURE_MESSAGE = 'SERVER_FAILURE_MESSAGE';
const CACHE_FAILURE_MESSAGE = 'CACHE_FAILURE_MESSAGE';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;

  PersonSearchBloc({required this.searchPerson}) : super(PersonEmpty());

  @override
  Stream<PersonSearchState> mapEventToState(PersonSearchEvent event) async* {
    if (event is SearchPersons) yield* _mapFetchPersonsToState(event.personQuery);
  }

  Stream<PersonSearchState> _mapFetchPersonsToState(String personQuery) async* {
    yield PersonSearchLoading();

    final failureOrPerson = await searchPerson(SearchPersonParams(query: personQuery));
    print(failureOrPerson);
    yield failureOrPerson.fold((failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
        (person) => PersonSearchLoaded(persons: person));
  }

  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
