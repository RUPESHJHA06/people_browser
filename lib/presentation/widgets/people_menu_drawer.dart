import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:people_browser/core/export.dart';
import 'package:people_browser/presentation/export.dart';

class PeopleMenuDrawer extends StatelessWidget {
  const PeopleMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.spacingLg,
                      AppSizes.spacingLg,
                      AppSizes.spacingLg,
                      AppSizes.spacingMd,
                    ),
                    child: Text(
                      AppStrings.menu,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const _ThemeModeSection(),
                  const Divider(height: 1),
                  const _FavoritesSection(),
                  const Divider(height: 1),
                  const _SortSection(),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.refresh),
                    title: const Text(AppStrings.refreshData),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.read<PeopleBloc>().add(
                        const PeopleRefreshRequested(),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text(AppStrings.about),
                    onTap: () {
                      Navigator.of(context).pop();
                      _showAboutSheet(context);
                    },
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              indent: AppSizes.spacingLg,
              endIndent: AppSizes.spacingLg,
              color: AppColors.tileBorderFor(theme.brightness),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spacingLg,
                AppSizes.spacingMd,
                AppSizes.spacingLg,
                AppSizes.spacingLg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.menuFooterPrefix,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textMutedFor(theme.brightness),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacingXs),
                      const Icon(
                        Icons.favorite,
                        color: AppColors.heartRed,
                        size: AppSizes.detailActionIconSize,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingSm),
                  Text(
                    AppStrings.menuFooterName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.textStrongFor(theme.brightness),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeSection extends StatelessWidget {
  const _ThemeModeSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return ExpansionTile(
          leading: const Icon(Icons.palette_outlined),
          title: const Text(AppStrings.theme),
          initiallyExpanded: true,
          children: [
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: themeMode,
              title: const Text(AppStrings.systemTheme),
              onChanged: (value) => _updateThemeMode(context, value),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: themeMode,
              title: const Text(AppStrings.lightTheme),
              onChanged: (value) => _updateThemeMode(context, value),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: themeMode,
              title: const Text(AppStrings.darkTheme),
              onChanged: (value) => _updateThemeMode(context, value),
            ),
          ],
        );
      },
    );
  }

  void _updateThemeMode(BuildContext context, ThemeMode? mode) {
    if (mode == null) {
      return;
    }

    context.read<ThemeCubit>().updateThemeMode(mode);
  }
}

class _FavoritesSection extends StatelessWidget {
  const _FavoritesSection();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PeopleBloc, PeopleState, bool>(
      selector: (state) => state.showFavoritesOnly,
      builder: (context, showFavoritesOnly) {
        return ListTile(
          leading: const Icon(Icons.favorite_outline),
          title: const Text(AppStrings.favoritesOnly),
          trailing: Switch(
            value: showFavoritesOnly,
            onChanged: (_) => context.read<PeopleBloc>().add(
              const PeopleFavoritesFilterToggled(),
            ),
          ),
        );
      },
    );
  }
}

class _SortSection extends StatelessWidget {
  const _SortSection();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PeopleBloc, PeopleState, PeopleSortOrder>(
      selector: (state) => state.sortOrder,
      builder: (context, sortOrder) {
        return ExpansionTile(
          leading: const Icon(Icons.sort_by_alpha),
          title: const Text(AppStrings.sortPeople),
          children: [
            RadioListTile<PeopleSortOrder>(
              value: PeopleSortOrder.nameAsc,
              groupValue: sortOrder,
              title: const Text(AppStrings.sortNameAz),
              onChanged: (value) => _updateSortOrder(context, value),
            ),
            RadioListTile<PeopleSortOrder>(
              value: PeopleSortOrder.nameDesc,
              groupValue: sortOrder,
              title: const Text(AppStrings.sortNameZa),
              onChanged: (value) => _updateSortOrder(context, value),
            ),
          ],
        );
      },
    );
  }

  void _updateSortOrder(BuildContext context, PeopleSortOrder? sortOrder) {
    if (sortOrder == null) {
      return;
    }

    context.read<PeopleBloc>().add(PeopleSortOrderChanged(sortOrder));
  }
}

void _showAboutSheet(BuildContext context) {
  final theme = Theme.of(context);

  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spacingLg,
            AppSizes.spacingMd,
            AppSizes.spacingLg,
            AppSizes.spacingLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.appTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.spacingSm),
              Text(
                AppStrings.aboutDescription,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    },
  );
}
