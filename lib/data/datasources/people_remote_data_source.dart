import '../models/user_model.dart';
import '../services/user_service.dart';

abstract class PeopleRemoteDataSource {
  Future<List<UserModel>> fetchPeople();
}

class PeopleRemoteDataSourceImpl implements PeopleRemoteDataSource {
  const PeopleRemoteDataSourceImpl(this._service);

  final UserService _service;

  @override
  Future<List<UserModel>> fetchPeople() => _service.fetchUsers();
}
