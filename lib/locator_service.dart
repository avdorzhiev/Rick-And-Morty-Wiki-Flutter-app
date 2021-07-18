import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:Rick_and_Morty_wiki/core/platform/network_info.dart';
import 'package:Rick_and_Morty_wiki/feature/data/datasources/person_local_data_source.dart';
import 'package:Rick_and_Morty_wiki/feature/data/datasources/person_remote_data_source.dart';
import 'package:Rick_and_Morty_wiki/feature/data/repositories/person_repository_impl.dart';
import 'package:Rick_and_Morty_wiki/feature/domain/repositories/person_repository.dart';
import 'package:Rick_and_Morty_wiki/feature/domain/usecases/get_all_persons.dart';
import 'package:Rick_and_Morty_wiki/feature/domain/usecases/search_person.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/block/person_list_cubit/person_list_cubit.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/block/search_bloc/search_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC / Cubit
  sl.registerFactory(
    () => PersonListCubit(getAllPersons: sl()),
  );
  sl.registerFactory(
    () => PersonSearchBloc(searchPerson: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAllPersons(sl()));
  sl.registerLazySingleton(() => SearchPerson(sl()));

  // Repository
  sl.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<PersonRemoteDataSource>(
    () => PersonRemoteDataSourceImpl(client: http.Client()),
  );

  sl.registerLazySingleton<PersonLocalDataSource>(
    () => PersonLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImp(sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
