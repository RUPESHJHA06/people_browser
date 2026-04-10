import 'package:flutter_test/flutter_test.dart';
import 'package:people_browser/core/core.dart';
import 'package:people_browser/domain/domain.dart';
import 'package:people_browser/presentation/bloc/bloc.dart';

void main() {
  test('loads people and exposes loaded state', () async {
    final bloc = PeopleBloc(GetPeople(_FakePeopleRepository(_people)));
    final loadingState = bloc.stream.firstWhere(
      (state) => state.status == PeopleStatus.loading,
    );
    final loadedState = bloc.stream.firstWhere(
      (state) => state.status == PeopleStatus.loaded,
    );

    bloc.add(const PeopleLoadRequested());

    expect((await loadingState).status, PeopleStatus.loading);
    final state = await loadedState;
    expect(state.people, _people);
    expect(state.filteredPeople, _people);
    await bloc.close();
  });

  test('sets error state when loading fails', () async {
    final bloc = PeopleBloc(
      GetPeople(_FakePeopleRepository.error('Network failed')),
    );
    final errorState = bloc.stream.firstWhere(
      (state) => state.status == PeopleStatus.error,
    );

    bloc.add(const PeopleLoadRequested());

    expect((await errorState).errorMessage, 'Network failed');
    await bloc.close();
  });

  test(
    'filters loaded people by name and reports empty search results',
    () async {
      final bloc = PeopleBloc(GetPeople(_FakePeopleRepository(_people)));
      final loadedState = bloc.stream.firstWhere(
        (state) => state.status == PeopleStatus.loaded,
      );

      bloc.add(const PeopleLoadRequested());
      await loadedState;

      final filteredState = bloc.stream.firstWhere(
        (state) =>
            state.status == PeopleStatus.loaded &&
            state.filteredPeople.length == 1,
      );
      bloc.add(const PeopleSearchQueryChanged('jane'));

      expect((await filteredState).filteredPeople, [_people.first]);

      final emptyState = bloc.stream.firstWhere(
        (state) => state.status == PeopleStatus.empty,
      );
      bloc.add(const PeopleSearchQueryChanged('nobody'));

      expect((await emptyState).filteredPeople, isEmpty);
      await bloc.close();
    },
  );

  test('sorts loaded people in descending name order', () async {
    final bloc = PeopleBloc(GetPeople(_FakePeopleRepository(_people)));
    final loadedState = bloc.stream.firstWhere(
      (state) => state.status == PeopleStatus.loaded,
    );

    bloc.add(const PeopleLoadRequested());
    await loadedState;

    final sortedState = bloc.stream.firstWhere(
      (state) =>
          state.sortOrder == PeopleSortOrder.nameDesc &&
          state.filteredPeople.first.fullName == 'John Smith',
    );
    bloc.add(const PeopleSortOrderChanged(PeopleSortOrder.nameDesc));

    final state = await sortedState;
    expect(state.filteredPeople, [_people.last, _people.first]);
    await bloc.close();
  });

  test('trims search queries before filtering people', () async {
    final bloc = PeopleBloc(GetPeople(_FakePeopleRepository(_people)));
    final loadedState = bloc.stream.firstWhere(
      (state) => state.status == PeopleStatus.loaded,
    );

    bloc.add(const PeopleLoadRequested());
    await loadedState;

    final filteredState = bloc.stream.firstWhere(
      (state) =>
          state.status == PeopleStatus.loaded &&
          state.searchQuery == 'jane' &&
          state.filteredPeople.length == 1,
    );
    bloc.add(const PeopleSearchQueryChanged('  jane  '));

    final state = await filteredState;
    expect(state.searchQuery, 'jane');
    expect(state.filteredPeople, [_people.first]);
    await bloc.close();
  });
}

const _people = [
  Person(
    id: '1',
    fullName: 'Jane Doe',
    email: 'jane@example.com',
    phone: '555-0100',
    location: 'Toronto, Canada',
    avatarUrl: 'https://example.com/jane.jpg',
    age: 32,
    gender: 'female',
  ),
  Person(
    id: '2',
    fullName: 'John Smith',
    email: 'john@example.com',
    phone: '555-0101',
    location: 'London, UK',
    avatarUrl: 'https://example.com/john.jpg',
    age: 41,
    gender: 'male',
  ),
];

class _FakePeopleRepository implements PeopleRepository {
  _FakePeopleRepository(this._people) : _errorMessage = null;

  _FakePeopleRepository.error(String errorMessage)
    : _people = const [],
      _errorMessage = errorMessage;

  final List<Person> _people;
  final String? _errorMessage;

  @override
  Future<List<Person>> getPeople() async {
    final errorMessage = _errorMessage;
    if (errorMessage != null) {
      throw AppException(errorMessage);
    }

    return _people;
  }
}
