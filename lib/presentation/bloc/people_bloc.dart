import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/core.dart';
import '../../domain/domain.dart';
import 'people_event.dart';
import 'people_state.dart';

class PeopleBloc extends Bloc<PeopleEvent, PeopleState> {
  PeopleBloc(this._getPeople) : super(const PeopleState()) {
    on<PeopleLoadRequested>(_onLoadRequested);
    on<PeopleRefreshRequested>(_onRefreshRequested);
    on<PeopleSearchQueryChanged>(_onSearchQueryChanged);
  }

  final GetPeople _getPeople;

  Future<void> _onLoadRequested(
    PeopleLoadRequested event,
    Emitter<PeopleState> emit,
  ) async {
    await _loadPeople(emit);
  }

  Future<void> _onRefreshRequested(
    PeopleRefreshRequested event,
    Emitter<PeopleState> emit,
  ) async {
    await _loadPeople(emit);
  }

  void _onSearchQueryChanged(
    PeopleSearchQueryChanged event,
    Emitter<PeopleState> emit,
  ) {
    final normalizedQuery = event.query.trim();
    if (normalizedQuery == state.searchQuery) {
      return;
    }

    final filteredPeople = _filterPeople(state.people, normalizedQuery);

    emit(
      state.copyWith(
        status: filteredPeople.isEmpty
            ? PeopleStatus.empty
            : PeopleStatus.loaded,
        filteredPeople: filteredPeople,
        searchQuery: normalizedQuery,
        clearError: true,
      ),
    );
  }

  Future<void> _loadPeople(Emitter<PeopleState> emit) async {
    if (state.status == PeopleStatus.loading) {
      return;
    }

    emit(state.copyWith(status: PeopleStatus.loading, clearError: true));

    try {
      final people = await _getPeople();
      final filteredPeople = _filterPeople(people, state.searchQuery);

      emit(
        state.copyWith(
          status: filteredPeople.isEmpty
              ? PeopleStatus.empty
              : PeopleStatus.loaded,
          people: people,
          filteredPeople: filteredPeople,
          clearError: true,
        ),
      );
    } on AppException catch (error) {
      emit(
        state.copyWith(status: PeopleStatus.error, errorMessage: error.message),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: PeopleStatus.error,
          errorMessage: 'Something went wrong while loading people.',
        ),
      );
    }
  }

  List<Person> _filterPeople(List<Person> people, String query) {
    if (query.isEmpty) {
      return people;
    }

    final lowerQuery = query.toLowerCase();
    return people
        .where((person) => person.fullName.toLowerCase().contains(lowerQuery))
        .toList(growable: false);
  }
}
