import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Rick_and_Morty_wiki/common/app_colors.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/block/person_list_cubit/person_list_cubit.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/block/search_bloc/search_bloc.dart';
import 'package:Rick_and_Morty_wiki/feature/presentation/pages/person_screen.dart';
import 'package:Rick_and_Morty_wiki/locator_service.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<PersonListCubit>(create: (context) => di.sl<PersonListCubit>()..loadPerson()),
          BlocProvider<PersonSearchBloc>(create: (context) => di.sl<PersonSearchBloc>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            backgroundColor: AppColors.mainBackground,
            scaffoldBackgroundColor: AppColors.mainBackground,
          ),
          home: HomePage(),
        ));
  }
}
