import 'package:dio/dio.dart';
import 'package:people_browser/core/export.dart';
import 'package:people_browser/data/export.dart';
import 'package:people_browser/domain/export.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  const PeopleRepositoryImpl(this._remoteDataSource);

  final PeopleRemoteDataSource _remoteDataSource;

  @override
  Future<List<Person>> getPeople() async {
    try {
      final models = await _remoteDataSource.fetchPeople();
      return models.map((model) => model.toEntity()).toList(growable: false);
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
