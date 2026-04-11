import 'package:people_browser/data/export.dart';

abstract class PeopleRemoteDataSource {
  Future<List<UserModel>> fetchPeople();
}

class PeopleRemoteDataSourceImpl implements PeopleRemoteDataSource {
  const PeopleRemoteDataSourceImpl(this._service);

  final UserService _service;

  @override
  Future<List<UserModel>> fetchPeople() => _service.fetchUsers();
}
