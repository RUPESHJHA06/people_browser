import 'package:people_browser/domain/export.dart';

abstract class PeopleRepository {
  Future<List<Person>> getPeople();
}
