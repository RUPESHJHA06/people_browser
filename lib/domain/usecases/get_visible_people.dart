import 'package:people_browser/domain/export.dart';

class GetVisiblePeople {
  const GetVisiblePeople();

  List<Person> call({
    required List<Person> people,
    required String query,
    required bool descending,
    required Set<String> favoriteIds,
    required bool showFavoritesOnly,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    final favoriteFilteredPeople = showFavoritesOnly
        ? people.where((person) => favoriteIds.contains(person.id))
        : people;
    final filteredPeople = normalizedQuery.isEmpty
        ? favoriteFilteredPeople
        : favoriteFilteredPeople.where((person) {
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
