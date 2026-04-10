import '../../domain/domain.dart';

enum PeopleStatus { initial, loading, loaded, empty, error }

class PeopleState {
  const PeopleState({
    this.status = PeopleStatus.initial,
    this.people = const [],
    this.filteredPeople = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  final PeopleStatus status;
  final List<Person> people;
  final List<Person> filteredPeople;
  final String searchQuery;
  final String? errorMessage;

  PeopleState copyWith({
    PeopleStatus? status,
    List<Person>? people,
    List<Person>? filteredPeople,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PeopleState(
      status: status ?? this.status,
      people: people ?? this.people,
      filteredPeople: filteredPeople ?? this.filteredPeople,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
