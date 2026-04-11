import 'package:flutter/material.dart';
import 'package:people_browser/core/constants/export.dart';
import 'package:people_browser/presentation/widgets/export.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawer: const PeopleMenuDrawer(),
        appBar: AppBar(
          title: const Text(AppStrings.appTitle),
          centerTitle: true,
          actions: const [PeopleFavoritesToggleButton()],
        ),
        body: const SafeArea(
          child: Column(
            children: [
              PeopleSearchSection(),
              Expanded(child: PeopleContent()),
            ],
          ),
        ),
      ),
    );
  }
}
