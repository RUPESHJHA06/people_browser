import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:people_browser/core/constants/export.dart';
import 'package:people_browser/domain/export.dart';
import 'package:people_browser/presentation/export.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawer: const _PeopleMenuDrawer(),
        appBar: AppBar(
          title: const Text(AppStrings.appTitle),
          centerTitle: true,
        ),
        body: const SafeArea(
          child: Column(
            children: [
              _PeopleSearchSection(),
              Expanded(child: _PeopleContent()),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeopleMenuDrawer extends StatelessWidget {
  const _PeopleMenuDrawer();

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

class _PeopleSearchSection extends StatefulWidget {
  const _PeopleSearchSection();

  @override
  State<_PeopleSearchSection> createState() => _PeopleSearchSectionState();
}

class _PeopleSearchSectionState extends State<_PeopleSearchSection> {
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final fillColor = AppColors.searchInputFillFor(brightness);
    return BlocSelector<PeopleBloc, PeopleState, bool>(
      selector: (state) =>
          state.status == PeopleStatus.loaded ||
          (state.status == PeopleStatus.empty && state.people.isNotEmpty),
      builder: (context, shouldShowSearch) {
        if (!shouldShowSearch) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spacingMd,
            AppSizes.spacingSm,
            AppSizes.spacingMd,
            AppSizes.spacingSm,
          ),
          child: TextField(
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: AppStrings.searchHint,
              prefixIcon: const Icon(Icons.search),
              fillColor: fillColor,
            ),
          ),
        );
      },
    );
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(AppConstants.searchDebounceDuration, () {
      context.read<PeopleBloc>().add(PeopleSearchQueryChanged(value));
    });
  }
}

class _PeopleContent extends StatelessWidget {
  const _PeopleContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeopleBloc, PeopleState>(
      builder: (context, state) {
        switch (state.status) {
          case PeopleStatus.initial:
          case PeopleStatus.loading:
            return const _LoadingPeopleSkeleton();
          case PeopleStatus.error:
            return _MessageState(
              icon: Icons.wifi_off,
              title: AppStrings.unableToLoadPeople,
              message: state.errorMessage ?? AppStrings.defaultRetryMessage,
              actionLabel: AppStrings.retry,
              onActionPressed: () =>
                  context.read<PeopleBloc>().add(const PeopleLoadRequested()),
            );
          case PeopleStatus.empty:
            return RefreshIndicator(
              onRefresh: () => _waitForRefresh(context),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: AppSizes.emptyStateTopSpacing),
                  _MessageState(
                    icon: Icons.person_search,
                    title: AppStrings.noPeopleFound,
                    message: state.people.isNotEmpty
                        ? AppStrings.noPeopleMessage
                        : AppStrings.defaultRetryMessage,
                  ),
                ],
              ),
            );
          case PeopleStatus.loaded:
            return const _PeopleList();
        }
      },
    );
  }
}

class _PeopleList extends StatelessWidget {
  const _PeopleList();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PeopleBloc, PeopleState, List<Person>>(
      selector: (state) => state.filteredPeople,
      builder: (context, people) {
        return RefreshIndicator(
          onRefresh: () => _waitForRefresh(context),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spacingMd,
              AppSizes.spacingSm,
              AppSizes.spacingMd,
              AppSizes.spacingMd,
            ),
            itemCount: people.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSizes.spacingSm),
            itemBuilder: (context, index) {
              final person = people[index];
              return SizedBox(
                key: ValueKey(person.id),
                height: AppSizes.personTileHeight,
                child: PersonTile(
                  person: person,
                  onTap: () => _openDetails(context, person),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _openDetails(BuildContext context, Person person) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PersonDetailPage(person: person)),
    );
  }
}

Future<void> _waitForRefresh(BuildContext context) async {
  final bloc = context.read<PeopleBloc>();
  if (bloc.state.status == PeopleStatus.loading) {
    return;
  }

  final nextSettledState = bloc.stream.firstWhere(
    (state) => state.status != PeopleStatus.loading,
  );
  bloc.add(const PeopleRefreshRequested());
  await nextSettledState;
}

class _LoadingPeopleSkeleton extends StatefulWidget {
  const _LoadingPeopleSkeleton();

  @override
  State<_LoadingPeopleSkeleton> createState() => _LoadingPeopleSkeletonState();
}

class _LoadingPeopleSkeletonState extends State<_LoadingPeopleSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.loadingPulseDuration,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final color = Color.lerp(
          AppColors.skeletonBaseFor(brightness),
          AppColors.skeletonHighlightFor(brightness),
          _animation.value,
        )!;

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.spacingMd),
          itemCount: 8,
          separatorBuilder: (_, __) =>
              const SizedBox(height: AppSizes.spacingSm),
          itemBuilder: (context, index) => _SkeletonTile(color: color),
        );
      },
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingMd),
        child: Row(
          children: [
            _SkeletonBox(
              color: color,
              width: AppSizes.avatarSizeMd,
              height: AppSizes.avatarSizeMd,
              borderRadius: AppSizes.skeletonCircleRadius,
            ),
            const SizedBox(width: AppSizes.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(
                    color: color,
                    widthFactor: 0.72,
                    height: AppSizes.skeletonLineHeightLg,
                  ),
                  const SizedBox(height: AppSizes.spacingSm),
                  _SkeletonBox(
                    color: color,
                    widthFactor: 0.92,
                    height: AppSizes.skeletonLineHeightSm,
                  ),
                  const SizedBox(height: AppSizes.spacingSm),
                  _SkeletonBox(
                    color: color,
                    widthFactor: 0.56,
                    height: AppSizes.skeletonLineHeightSm,
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

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.color,
    required this.height,
    this.width,
    this.widthFactor,
    this.borderRadius = AppSizes.radiusSm,
  });

  final Color color;
  final double height;
  final double? width;
  final double? widthFactor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );

    final factor = widthFactor;
    if (factor == null) {
      return box;
    }

    return FractionallySizedBox(
      widthFactor: factor,
      alignment: Alignment.centerLeft,
      child: box,
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSizes.messageIconSize,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSizes.spacingMd),
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSizes.spacingSm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: AppSizes.spacingMd),
              FilledButton(
                onPressed: onActionPressed,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
