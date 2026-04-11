import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:people_browser/core/export.dart';
import 'package:people_browser/presentation/export.dart';

class PeopleFavoritesToggleButton extends StatelessWidget {
  const PeopleFavoritesToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PeopleBloc, PeopleState, ({bool enabled, int count})>(
      selector: (state) =>
          (enabled: state.showFavoritesOnly, count: state.favoriteIds.length),
      builder: (context, data) {
        return IconButton(
          onPressed: () => context.read<PeopleBloc>().add(
            const PeopleFavoritesFilterToggled(),
          ),
          tooltip: AppStrings.favoritesOnly,
          icon: Badge.count(
            isLabelVisible: data.count > 0,
            count: data.count,
            child: Icon(
              data.enabled ? Icons.favorite : Icons.favorite_border,
              color: data.enabled ? AppColors.heartRed : null,
            ),
          ),
        );
      },
    );
  }
}
