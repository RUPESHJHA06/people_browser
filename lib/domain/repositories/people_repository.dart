import '../entities/person.dart';

abstract class PeopleRepository {
  Future<List<Person>> getPeople();
}
