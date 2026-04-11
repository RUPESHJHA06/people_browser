import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:people_browser/core/export.dart';
import 'package:people_browser/domain/export.dart';
import 'package:people_browser/presentation/export.dart';

class PeopleBrowserApp extends StatelessWidget {
  const PeopleBrowserApp({
    super.key,
    required this.getPeople,
    required this.getVisiblePeople,
  });

  final GetPeople getPeople;
  final GetVisiblePeople getVisiblePeople;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PeopleBloc(
            getPeople: getPeople,
            getVisiblePeople: getVisiblePeople,
          )..add(const PeopleLoadRequested()),
        ),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: AppStrings.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeMode,
            builder: (context, child) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
