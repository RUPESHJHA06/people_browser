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
    on<PeopleSortOrderChanged>(_onSortOrderChanged);
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

    _emitVisiblePeopleState(
      emit,
      people: state.people,
      query: normalizedQuery,
      sortOrder: state.sortOrder,
      searchQuery: normalizedQuery,
    );
  }

  void _onSortOrderChanged(
    PeopleSortOrderChanged event,
    Emitter<PeopleState> emit,
  ) {
    if (event.sortOrder == state.sortOrder) {
      return;
    }

    _emitVisiblePeopleState(
      emit,
      people: state.people,
      query: state.searchQuery,
      sortOrder: event.sortOrder,
    );
  }

  Future<void> _loadPeople(Emitter<PeopleState> emit) async {
    if (state.status == PeopleStatus.loading) {
      return;
    }

    emit(state.copyWith(status: PeopleStatus.loading, clearError: true));

    try {
      final people = await _getPeople();
      _emitVisiblePeopleState(
        emit,
        people: people,
        query: state.searchQuery,
        sortOrder: state.sortOrder,
      );
    } on AppException catch (error) {
      emit(_buildErrorState(error.message));
    } catch (_) {
      emit(_buildErrorState('Something went wrong while loading people.'));
    }
  }

  void _emitVisiblePeopleState(
    Emitter<PeopleState> emit, {
    required List<Person> people,
    required String query,
    required PeopleSortOrder sortOrder,
    String? searchQuery,
  }) {
    final filteredPeople = _buildVisiblePeople(
      people: people,
      query: query,
      sortOrder: sortOrder,
    );

    emit(
      state.copyWith(
        status: _resolveVisibleStatus(filteredPeople),
        people: people,
        filteredPeople: filteredPeople,
        searchQuery: searchQuery,
        sortOrder: sortOrder,
        clearError: true,
      ),
    );
  }

  PeopleState _buildErrorState(String message) {
    return state.copyWith(status: PeopleStatus.error, errorMessage: message);
  }

  PeopleStatus _resolveVisibleStatus(List<Person> filteredPeople) {
    return filteredPeople.isEmpty ? PeopleStatus.empty : PeopleStatus.loaded;
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

  List<Person> _buildVisiblePeople({
    required List<Person> people,
    required String query,
    required PeopleSortOrder sortOrder,
  }) {
    final filteredPeople = _filterPeople(people, query);
    final sortedPeople = List<Person>.of(filteredPeople);

    sortedPeople.sort((first, second) {
      final result = first.fullName.toLowerCase().compareTo(
        second.fullName.toLowerCase(),
      );
      return sortOrder == PeopleSortOrder.nameAsc ? result : -result;
    });

    return sortedPeople;
  }
}
