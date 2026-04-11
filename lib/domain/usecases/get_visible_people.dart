import 'package:people_browser/domain/export.dart';

class GetVisiblePeople {
  const GetVisiblePeople();

  List<Person> call({
    required List<Person> people,
    required String query,
    required bool descending,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    final filteredPeople = normalizedQuery.isEmpty
        ? people
        : people.where((person) {
            return person.fullName.toLowerCase().contains(normalizedQuery);
          });

    final sortedPeople = filteredPeople.toList(growable: false);
    sortedPeople.sort((first, second) {
      final result = first.fullName.toLowerCase().compareTo(
        second.fullName.toLowerCase(),
      );
      return descending ? -result : result;
    });

    return sortedPeople;
  }
}
