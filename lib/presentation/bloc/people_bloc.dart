import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:people_browser/core/export.dart';
import 'package:people_browser/domain/export.dart';

import 'people_event.dart';
import 'people_state.dart';

class PeopleBloc extends Bloc<PeopleEvent, PeopleState> {
  PeopleBloc({
    required GetPeople getPeople,
    required GetVisiblePeople getVisiblePeople,
  }) : _getPeople = getPeople,
       _getVisiblePeople = getVisiblePeople,
       super(const PeopleState()) {
    on<PeopleLoadRequested>(_onLoadRequested);
    on<PeopleRefreshRequested>(_onRefreshRequested);
    on<PeopleSearchQueryChanged>(_onSearchQueryChanged);
    on<PeopleSortOrderChanged>(_onSortOrderChanged);
    on<PeopleFavoriteToggled>(_onFavoriteToggled);
    on<PeopleFavoritesFilterToggled>(_onFavoritesFilterToggled);
  }

  final GetPeople _getPeople;
  final GetVisiblePeople _getVisiblePeople;

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
      favoriteIds: state.favoriteIds,
      showFavoritesOnly: state.showFavoritesOnly,
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
      favoriteIds: state.favoriteIds,
      showFavoritesOnly: state.showFavoritesOnly,
    );
  }

  void _onFavoriteToggled(
    PeopleFavoriteToggled event,
    Emitter<PeopleState> emit,
  ) {
    final favoriteIds = Set<String>.of(state.favoriteIds);
    if (favoriteIds.contains(event.personId)) {
      favoriteIds.remove(event.personId);
    } else {
      favoriteIds.add(event.personId);
    }

    _emitVisiblePeopleState(
      emit,
      people: state.people,
      query: state.searchQuery,
      sortOrder: state.sortOrder,
      favoriteIds: favoriteIds,
      showFavoritesOnly: state.showFavoritesOnly,
    );
  }

  void _onFavoritesFilterToggled(
    PeopleFavoritesFilterToggled event,
    Emitter<PeopleState> emit,
  ) {
    _emitVisiblePeopleState(
      emit,
      people: state.people,
      query: state.searchQuery,
      sortOrder: state.sortOrder,
      favoriteIds: state.favoriteIds,
      showFavoritesOnly: !state.showFavoritesOnly,
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
        favoriteIds: state.favoriteIds,
        showFavoritesOnly: state.showFavoritesOnly,
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
    required Set<String> favoriteIds,
    required bool showFavoritesOnly,
    String? searchQuery,
  }) {
    final filteredPeople = _getVisiblePeople(
      people: people,
      query: query,
      descending: sortOrder == PeopleSortOrder.nameDesc,
      favoriteIds: favoriteIds,
      showFavoritesOnly: showFavoritesOnly,
    );

    emit(
      state.copyWith(
        status: _resolveVisibleStatus(filteredPeople),
        people: people,
        filteredPeople: filteredPeople,
        searchQuery: searchQuery,
        sortOrder: sortOrder,
        favoriteIds: favoriteIds,
        showFavoritesOnly: showFavoritesOnly,
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
}
