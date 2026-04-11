import 'package:people_browser/domain/export.dart';

enum PeopleStatus { initial, loading, loaded, empty, error }

enum PeopleSortOrder { nameAsc, nameDesc }

class PeopleState {
  const PeopleState({
    this.status = PeopleStatus.initial,
    this.people = const [],
    this.filteredPeople = const [],
    this.searchQuery = '',
    this.sortOrder = PeopleSortOrder.nameAsc,
    this.favoriteIds = const {},
    this.showFavoritesOnly = false,
    this.errorMessage,
  });

  final PeopleStatus status;
  final List<Person> people;
  final List<Person> filteredPeople;
  final String searchQuery;
  final PeopleSortOrder sortOrder;
  final Set<String> favoriteIds;
  final bool showFavoritesOnly;
  final String? errorMessage;

  PeopleState copyWith({
    PeopleStatus? status,
    List<Person>? people,
    List<Person>? filteredPeople,
    String? searchQuery,
    PeopleSortOrder? sortOrder,
    Set<String>? favoriteIds,
    bool? showFavoritesOnly,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PeopleState(
      status: status ?? this.status,
      people: people ?? this.people,
      filteredPeople: filteredPeople ?? this.filteredPeople,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOrder: sortOrder ?? this.sortOrder,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
