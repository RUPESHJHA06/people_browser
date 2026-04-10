import 'package:dio/dio.dart';

import '../../core/core.dart';
import '../../domain/domain.dart';
import '../datasources/people_remote_data_source.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  const PeopleRepositoryImpl(this._remoteDataSource);

  final PeopleRemoteDataSource _remoteDataSource;

  @override
  Future<List<Person>> getPeople() async {
    try {
      return await _remoteDataSource.fetchPeople();
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        throw AppException(
          'Could not load people. Server returned $statusCode.',
        );
      }
      throw const AppException('Could not load people. Check your connection.');
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('Something went wrong while loading people.');
    }
  }
}
