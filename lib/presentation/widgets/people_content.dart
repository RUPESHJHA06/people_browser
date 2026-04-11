import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:people_browser/core/constants/export.dart';
import 'package:people_browser/domain/export.dart';
import 'package:people_browser/presentation/export.dart';

class PeopleContent extends StatelessWidget {
  const PeopleContent({super.key});

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
            return _RefreshablePeopleView(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: AppSizes.emptyStateTopSpacing),
                  _EmptyPeopleState(state: state),
                ],
              ),
            );
          case PeopleStatus.loaded:
            return const _PeopleListView();
        }
      },
    );
  }
}

class _EmptyPeopleState extends StatelessWidget {
  const _EmptyPeopleState({required this.state});

  final PeopleState state;

  @override
  Widget build(BuildContext context) {
    if (state.people.isEmpty) {
      return const _MessageState(
        icon: Icons.person_search,
        title: AppStrings.noPeopleFound,
        message: AppStrings.defaultRetryMessage,
      );
    }

    if (state.showFavoritesOnly && state.favoriteIds.isEmpty) {
      return const _MessageState(
        icon: Icons.favorite_border,
        title: AppStrings.noFavoritesYet,
        message: AppStrings.noFavoritesMessage,
      );
    }

    if (state.showFavoritesOnly) {
      return const _MessageState(
        icon: Icons.heart_broken_outlined,
        title: AppStrings.noPeopleFound,
        message: AppStrings.noFavoriteMatches,
      );
    }

    return const _MessageState(
      icon: Icons.person_search,
      title: AppStrings.noPeopleFound,
      message: AppStrings.noPeopleMessage,
    );
  }
}

class _PeopleListView extends StatelessWidget {
  const _PeopleListView();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PeopleBloc, PeopleState, List<Person>>(
      selector: (state) => state.filteredPeople,
      builder: (context, people) {
        return _RefreshablePeopleView(
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
                child: _PeopleListItem(
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

class _PeopleListItem extends StatelessWidget {
  const _PeopleListItem({required this.person, required this.onTap});

  final Person person;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<PeopleBloc, bool>(
      (bloc) => bloc.state.favoriteIds.contains(person.id),
    );

    return PersonTile(
      person: person,
      onTap: onTap,
      isFavorite: isFavorite,
      onFavoriteToggle: () =>
          context.read<PeopleBloc>().add(PeopleFavoriteToggled(person.id)),
    );
  }
}

class _RefreshablePeopleView extends StatelessWidget {
  const _RefreshablePeopleView({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _waitForRefresh(context),
      child: child,
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
