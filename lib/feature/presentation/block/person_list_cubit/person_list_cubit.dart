import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Rick_and_Morty_wiki/core/error/failure.dart';
import 'package:Rick_and_Morty_wiki/feature/domain/entities/person_entity.dart';
import 'package:Rick_and_Morty_wiki/feature/domain/usecases/get_all_persons.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/block/person_list_cubit/person_list_state.dart';

const SERVER_FAILURE_MESSAGE = 'SERVER FAILURE MESSAGE';
const CACHE_FAILURE_MESSAGE = 'CACHE FAILURE MESSAGE';

class PersonListCubit extends Cubit<PersonState> {
  final GetAllPersons getAllPersons;

  PersonListCubit({required this.getAllPersons}) : super(PersonEmpty());

  int page = 1;

  Future<void> loadPerson() async {
    if (state is PersonLoading) return;

    final currentState = state;
    var oldPerson = <PersonEntity>[];
    if (currentState is PersonLoaded) {
      oldPerson = currentState.personsList;
    }

    emit(PersonLoading(oldPerson, isFirstFetch: page == 1));

    final failureOrPerson = await getAllPersons(PagePersonParams(page: page));

    failureOrPerson.fold((error) => emit(PersonError(message:  _mapFailureToMessage(error))), (character) {
      page++;
      final persons = (state as PersonLoading).oldPersonsList;
      persons.addAll(character);
      print('List length: ${persons.length.toString()}');
      emit(PersonLoaded(persons));
    });
  }

  String _mapFailureToMessage(error) {
    switch (error.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
