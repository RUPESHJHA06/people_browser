import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/core.dart';
import '../../domain/domain.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';
import 'person_detail_page.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
