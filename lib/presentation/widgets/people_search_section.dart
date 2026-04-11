import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:people_browser/core/export.dart';
import 'package:people_browser/presentation/export.dart';

class PeopleSearchSection extends StatefulWidget {
  const PeopleSearchSection({super.key});

  @override
  State<PeopleSearchSection> createState() => _PeopleSearchSectionState();
}

class _PeopleSearchSectionState extends State<PeopleSearchSection> {
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
