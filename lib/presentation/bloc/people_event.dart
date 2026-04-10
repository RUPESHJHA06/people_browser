import 'people_state.dart';

abstract class PeopleEvent {
  const PeopleEvent();
}

class PeopleLoadRequested extends PeopleEvent {
  const PeopleLoadRequested();
}

class PeopleRefreshRequested extends PeopleEvent {
  const PeopleRefreshRequested();
}

class PeopleSearchQueryChanged extends PeopleEvent {
  const PeopleSearchQueryChanged(this.query);

  final String query;
}

class PeopleSortOrderChanged extends PeopleEvent {
  const PeopleSortOrderChanged(this.sortOrder);

  final PeopleSortOrder sortOrder;
}
