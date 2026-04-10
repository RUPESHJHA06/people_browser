import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/core.dart';
import 'data/data.dart';
import 'domain/domain.dart';
import 'presentation/bloc/bloc.dart';
import 'presentation/pages/pages.dart';

void main() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: AppConstants.requestTimeout,
      receiveTimeout: AppConstants.requestTimeout,
    ),
  );
  final userService = UserService(dio);
  final peopleRemoteDataSource = PeopleRemoteDataSourceImpl(userService);
  final peopleRepository = PeopleRepositoryImpl(peopleRemoteDataSource);
  final getPeople = GetPeople(peopleRepository);

  runApp(PeopleBrowserApp(getPeople: getPeople));
}

class PeopleBrowserApp extends StatelessWidget {
  const PeopleBrowserApp({super.key, required this.getPeople});

  final GetPeople getPeople;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PeopleBloc(getPeople)..add(const PeopleLoadRequested()),
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        builder: (context, child) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const SplashPage(),
      ),
    );
  }
}
