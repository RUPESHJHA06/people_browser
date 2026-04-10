import '../entities/person.dart';
import '../repositories/people_repository.dart';

class GetPeople {
  const GetPeople(this._repository);

  final PeopleRepository _repository;

  Future<List<Person>> call() => _repository.getPeople();
}
