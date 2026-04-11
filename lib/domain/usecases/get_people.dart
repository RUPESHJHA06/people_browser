import 'package:people_browser/domain/export.dart';

class GetPeople {
  const GetPeople(this._repository);

  final PeopleRepository _repository;

  Future<List<Person>> call() => _repository.getPeople();
}
